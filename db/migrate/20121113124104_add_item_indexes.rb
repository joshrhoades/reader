class AddItemIndexes < ActiveRecord::Migration
  def change
    add_index :items, %w{unread starred shared has_new_comments}, :name => "items_flags"
  end
end
