class ExpireClient
  include Sidekiq::Worker
  sidekiq_options :queue => :clients
  def perform(id)

    Client.where(:id => id).each do |client|
      client.destroy
    end
  end
end
