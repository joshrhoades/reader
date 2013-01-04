class AddSoftDeleteSubscription < ActiveRecord::Migration
  def change
    add_column :subscriptions, :deleted, :boolean, :default => false
  end
end
