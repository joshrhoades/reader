class NewUserSetup
  include Sidekiq::Worker
  sidekiq_options :queue => :users
  def perform(id)
    user = User.find id

    user.subscriptions.each do |sub|
      sub.feed.entries.where("created_at > ?", Date.current - 2.weeks).each do |entry|
        item = Item.new(:user_id => sub.user_id, :entry => entry, :subscription => sub)
        if item.valid?
          item.save
        end
      end
    end
  end
end