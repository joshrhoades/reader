class AddFeedIndexes < ActiveRecord::Migration
  def change
    add_index :feeds, "id", :name => "feeds_id"
  end
end
