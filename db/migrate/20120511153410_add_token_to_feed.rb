class AddTokenToFeed < ActiveRecord::Migration
  def change
    add_column :feeds, :token, :string
  end
end
