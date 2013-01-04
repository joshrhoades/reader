class AddSharedFeedToUser < ActiveRecord::Migration
  def change
    add_column :users, :shared_feed_id, :integer
    add_column :users, :starred_feed_id, :integer
  end
end
