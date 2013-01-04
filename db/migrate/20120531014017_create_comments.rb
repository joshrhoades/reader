class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :user_id, :null => false
      t.integer :item_id, :null => false
      t.text :body, :null => false
      t.boolean :edited, :default => false

      t.timestamps
    end
  end
end
