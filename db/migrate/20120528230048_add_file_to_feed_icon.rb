class AddFileToFeedIcon < ActiveRecord::Migration
  def change
    add_column :feed_icons, :feed_icon, :string
  end
end
