module Feeder
  class Base
    class << self
      attr :feeds, :pushed_feeds, :polled_feeds
      def run!
        Sidekiq.redis do |r|
          r.del("queue:poll")
          r.srem("queues", "poll")
          r.zremrangebyrank("schedule", 0, -1)
        end

        @pushed_feeds = []
        @polled_feeds = []
        if Rails.env.development?
          Entry.delete_all; Item.delete_all; EntryGuid.delete_all;
          @feeds = User.charlie.feeds
        else
          @feeds = Feed.fetchable
        end

        @feeds.each do |feed|
          if feed.push_enabled?
            @pushed_feeds << feed
          end
          @polled_feeds << feed
        end

        subscribe_to_pushed_feeds if Rails.env.production?
        poll_polled_feeds

        UpdateSubscriptionCount.perform_async
        UpdateIcon.perform_in 30.minutes
        nil
      end

      def unsubscribe_all!
        self.pushed_feeds.each do |feed|
          unsubscribe feed
        end
      end

      def subscribe_to_pushed_feeds
        self.pushed_feeds.each do |feed|
          subscribe(feed) unless feed.push_subscribed?
        end
      end

      def subscribe(feed)
        Faraday.post feed.hub, payload_for(feed)
      end

      def unsubscribe(feed)
        payload = payload_for(feed)
        payload["hub.mode"] = 'unsubscribe'
        Faraday.post feed.hub, payload
      end

      def payload_for(feed)
        unless feed.secret_token
          feed.secret_token = rand(36**40).to_s(36)
          feed.save!
        end

        {
          "hub.callback" => "http://1kpl.us/feeder/receiver/#{feed.token}/",
          "hub.mode" => "subscribe",
          "hub.topic" => feed.topic,
          "hub.verify" => "async",
          "hub.verify_token" => feed.secret_token
        }
      end

      def poll_polled_feeds
        self.polled_feeds.each do |feed|
          PollFeed.perform_async(feed.id)
        end
      end

    end

  end
end