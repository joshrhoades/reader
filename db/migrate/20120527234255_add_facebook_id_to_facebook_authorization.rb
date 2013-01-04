class AddFacebookIdToFacebookAuthorization < ActiveRecord::Migration
  def change
    add_column :facebook_authorizations, :facebook_id, :string
  end
end
