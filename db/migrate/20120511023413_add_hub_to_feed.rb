class AddHubToFeed < ActiveRecord::Migration
  def change
    add_column :feeds, :hub, :text
  end
end
