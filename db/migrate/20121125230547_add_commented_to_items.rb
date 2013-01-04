class AddCommentedToItems < ActiveRecord::Migration
  def change
    add_column :items, :commented, :boolean, :default => false
  end
end
