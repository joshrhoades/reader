class AddPossibleFacebookContactTable < ActiveRecord::Migration
  def up
    create_table :facebook_contacts do |t|
      t.integer :left_user_id
      t.integer :right_user_id
      t.string :names
      t.timestamps
    end
  end

  def down
    drop_table :facebook_contacts
  end
end
