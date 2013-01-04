class AddNewCommentsToItem < ActiveRecord::Migration
  def change
    add_column :items, :has_new_comments, :boolean
  end
end
