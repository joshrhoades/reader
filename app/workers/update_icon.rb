class UpdateIcon
  include Sidekiq::Worker
  sidekiq_options :queue => :background
  def perform
    UpdateIcon.perform_in 12.hours
    Feed.get_icons
  end
end