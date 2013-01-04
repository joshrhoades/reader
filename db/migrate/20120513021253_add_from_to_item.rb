class AddFromToItem < ActiveRecord::Migration
  def change
    add_column :items, :from_id, :integer
  end
end
