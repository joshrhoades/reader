class CreateFacebookAuthorizations < ActiveRecord::Migration
  def change
    create_table :facebook_authorizations do |t|
      t.integer :user_id
      t.text :token
      t.datetime :token_expires_at
      t.text :auth_hash

      t.timestamps
    end
  end
end
