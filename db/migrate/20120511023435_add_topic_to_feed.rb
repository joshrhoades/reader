class AddTopicToFeed < ActiveRecord::Migration
  def change
    add_column :feeds, :topic, :text
  end
end
