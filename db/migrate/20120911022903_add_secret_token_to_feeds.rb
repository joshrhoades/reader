class AddSecretTokenToFeeds < ActiveRecord::Migration
  def change
    add_column :feeds, :secret_token, :string
  end
end
