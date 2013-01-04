class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.references :user,                            :null => false
      t.references :entry
      t.references :subscription
      t.boolean  "unread",          :default => true
      t.boolean  "starred",         :default => false
      t.boolean  "shared",          :default => false
      t.boolean  "browsed",         :default => false
      t.boolean  "liked",           :default => false
      t.references  :item
      t.timestamps
    end
    add_index :items, :id
    add_index :items, :user_id
    add_index :items, :entry_id
    add_index :items, :subscription_id
    add_index :items, ["user_id", "entry_id"], :unique => true,     :name => "item_user_entry"
  end
end
