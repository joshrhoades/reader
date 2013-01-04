class AddPublicTokenToUser < ActiveRecord::Migration
  def change
    add_column :users, :public_token, :string, :null => false
  end
end
