class AddAllCountToSubscription < ActiveRecord::Migration
  def change
    add_column :subscriptions, :all_count, :integer
  end
end
