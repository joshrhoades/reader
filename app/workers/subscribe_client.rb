class SubscribeClient
  include Sidekiq::Worker
  sidekiq_options :queue => :clients
  def perform(client_id, channel)
    puts "subscribe client - #{client_id}, #{channel}"
    token = channel.split('/').last
    user = User.where(:websocket_token => token.to_s).first

    Client.where(:user_id => user.id).map(&:destroy) if user
    Client.create(:user_id => user.id, :client_id => client_id, :channel => channel) if user
  end
end