class AddFetchableToFeed < ActiveRecord::Migration
  def change
    add_column :feeds, :fetchable, :boolean, :default => true
  end
end
