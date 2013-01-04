class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :label
      t.string :key
      t.references :user
      t.timestamps
    end
    add_index :groups, ["user_id", "key"], :unique => true,     :name => "user_key"
  end

end
