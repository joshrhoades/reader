class RevokeItem
  include Sidekiq::Worker
  sidekiq_options :queue => :items
  def perform(id, user_id)
    # puts "revoke item - #{id}"
    Client.where(:user_id => user_id).limit(1).each do |client|

      begin
        PrivatePub.publish_to client.channel, "App.receiver.removeItem(#{id})"
        # puts "Item #{id} revoked from user #{user_id} via #{client.client_id}:#{client.channel}"
      rescue Errno::ECONNREFUSED
        client.destroy
      end

    end

  end
end