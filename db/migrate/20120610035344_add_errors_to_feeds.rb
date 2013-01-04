class AddErrorsToFeeds < ActiveRecord::Migration
  def change
    add_column :feeds, :parse_errors, :integer, :default => 0
  end
end
