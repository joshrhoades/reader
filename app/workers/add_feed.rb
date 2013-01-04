class AddFeed
  include Sidekiq::Worker
  sidekiq_options :queue => :feeds
  def perform(url)
    Rails.logger.info "add feed - #{url}"
  end
end
