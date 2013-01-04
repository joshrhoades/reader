class AddShareDeliveredToItem < ActiveRecord::Migration
  def change
    add_column :items, :share_delivered, :boolean, :default => false
  end
end
