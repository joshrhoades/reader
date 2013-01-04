class AddPushSubscribedToFeeds < ActiveRecord::Migration
  def change
    add_column :feeds, :push_subscribed, :boolean, :default => false
  end
end
