class ShareItem
  include Sidekiq::Worker
  sidekiq_options :queue => :items
  def perform(id)
    item = Item.find id
    user = item.user
    follower_count = 0
    user.followers.each do |follower|
      follower_count += 1
      new_item = Item.new(user_id: follower.id, entry_id: item.entry_id, subscription_id: item.subscription_id, parent_id: item.id, from_id: user.id)
      new_item.from_id = user.id
      unless new_item.save
        ap "Shared item did not save"
        ap new_item.errors
      end
    end

    item.update_column :share_delivered, true

  rescue ActiveRecord::RecordNotUnique => e

  end
end