class AddEtagToFeeds < ActiveRecord::Migration
  def change
    add_column :feeds, :etag, :string
  end
end
