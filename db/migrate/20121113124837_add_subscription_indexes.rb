class AddSubscriptionIndexes < ActiveRecord::Migration
  def change
    add_index :subscriptions, "id", :name => "subscriptions_id"
  end
end
