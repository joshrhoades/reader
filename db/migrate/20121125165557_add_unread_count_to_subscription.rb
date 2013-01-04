class AddUnreadCountToSubscription < ActiveRecord::Migration
  def change
    add_column :subscriptions, :unread_count, :integer
    add_column :subscriptions, :starred_count, :integer
    add_column :subscriptions, :shared_count, :integer
  end
end
