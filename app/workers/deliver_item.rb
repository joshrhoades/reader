class DeliverItem
  include Sidekiq::Worker
  sidekiq_options :queue => :items
  def perform(id, user_id)

    Client.where(:user_id => user_id).each do |client|
      item = Item.where(:id => id).first
      unless item.nil?
        json = Jbuilder.encode do |json|
          json.(item, :id, :user_id, :from_id, :parent_id, :subscription_id, :unread, :starred, :shared, :commented, :created_at, :updated_at, :entry_id, :has_new_comments)
          json.feed_id item.feed.id if item.feed
          json.(item.entry, :title, :author, :url, :published_at)
          json.content item.entry.sanitized_content.to_s
          json.formatted_published_at item.entry.pubdate
          json.comments item.comments do |comment|
            json.(comment, :id, :user_id, :body, :html, :item_id, :created_at)
            json.name comment.user.name
          end
        end

        puts "Deliver Item #{id} to user #{user_id} via #{client.client_id}:#{client.channel}"
        begin
          PrivatePub.publish_to client.channel, "App.receiver.addItem(#{json})"
        rescue Errno::ECONNREFUSED
          client.destroy
        end
      end
    end
  end
end
