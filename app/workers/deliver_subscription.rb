class DeliverSubscription
  include Sidekiq::Worker
  sidekiq_options :queue => :subscriptions
  def perform(id, user_id)

    Client.where(:user_id => user_id).each do |client|
      sub = Subscription.where(:id => id).first
      unless sub.nil?
        json = Jbuilder.encode do |json|
          json.(sub, :id, :user_id, :group_id, :unread_count, :starred_count, :shared_count, :commented_count, :all_count, :created_at, :updated_at)
        end

        ap "Deliver subscription #{id} to user #{user_id} via #{client.client_id}:#{client.channel}"
        begin
          PrivatePub.publish_to client.channel, "App.receiver.addSubscription(#{json})"
        rescue Errno::ECONNREFUSED
          client.destroy
        end
      end
    end
  end
end
