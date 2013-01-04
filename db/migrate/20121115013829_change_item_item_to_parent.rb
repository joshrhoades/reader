class ChangeItemItemToParent < ActiveRecord::Migration
  def change
    rename_column :items, :item_id, :parent_id
  end
end
