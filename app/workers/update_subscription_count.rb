class UpdateSubscriptionCount
  include Sidekiq::Worker
  sidekiq_options :queue => :background
  def perform
    UpdateSubscriptionCount.perform_in 1.hours
    Subscription.update_counts
  end
end