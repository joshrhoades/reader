require 'faraday_middleware'
require 'faraday_middleware/response_middleware'
class PollFeed
  include Sidekiq::Worker
  sidekiq_options :queue => :poll
  def perform(id)
    feed = Feed.find(id)
    return unless feed.fetchable?
    if feed
      etag = feed.etag
      conn = Faraday.new(:url => feed.feed_url) do |c|
        c.response :follow_redirects
        c.adapter Faraday.default_adapter
      end
      response = conn.get do |request|
        request.headers['If-None-Match'] = etag if etag
      end
      feed.etag = response.headers[:etag]
      feed.fetched_at = Time.now
      feed.fetchable = true

      case response.status
        when 200
          if response.body && response.body.present?
            body = response.body.ensure_encoding('UTF-8', :external_encoding  => :sniff, :invalid_characters => :transcode)
            parsed_feed = Feedzirra::Feed.parse(body) do |t|
              feed.parse_errors ||= 0
              feed.parse_errors = feed.parse_errors + 1
              feed.fetchable = false if feed.parse_errors > 10
              feed.save
              return
            end


            parsed_feed.entries.each do |entry|
              ProcessEntry.new.perform(feed.id, entry.content, entry.summary, entry.entry_id, entry.url, entry.published.to_s, entry.updated.to_s, entry.title, entry.author)
            end

            # check if feed is now push capable
            unless parsed_feed.hub.nil?
              feed.hub = parsed_feed.hub.to_s
              feed.topic = parsed_feed.self.to_s
            end

            #if feed.push_enabled?
            #  Feeder::Base.subscribe(feed)
            #else
              PollFeed.perform_in(Reader::UPDATE_FREQUENCY.minutes, id)
            #end
          end
        when 400..599, 304
          PollFeed.perform_in(6.hours, id)
        else
          PollFeed.perform_in(6.hours, id)
      end
    end

  rescue ActiveRecord::RecordNotFound => e
    # do nothing
  rescue TypeError => e
    PollFeed.perform_in(3.hours, id)
  rescue Faraday::Error::TimeoutError => e
    # try later
    PollFeed.perform_in(3.hours, id)
  rescue Errno::ETIMEDOUT => e
    # try later
    PollFeed.perform_in(3.hours, id)
  rescue FaradayMiddleware::RedirectLimitReached => e
    # try later
    PollFeed.perform_in(3.hours, id)
  rescue Faraday::Error::ConnectionFailed => e
    # try later
    PollFeed.perform_in(3.hours, id)
  rescue Feedzirra::NoParserAvailable => e
    # try a lot later
    PollFeed.perform_in(3.days, id)
  ensure
    feed.save if feed
  end
end
