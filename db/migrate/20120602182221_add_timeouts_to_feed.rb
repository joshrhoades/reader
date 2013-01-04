class AddTimeoutsToFeed < ActiveRecord::Migration
  def change
    add_column :feeds, :timeouts, :integer, :default => 0
  end
end
