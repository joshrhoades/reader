class AddCommentIndexes < ActiveRecord::Migration
  def change
    add_index :comments, "item_id", :name => "comments_item_id"
    add_index :comments, "id", :name => "comments_id"
  end
end
