class AddWeightToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :weight, :integer, :default => 0
  end
end
