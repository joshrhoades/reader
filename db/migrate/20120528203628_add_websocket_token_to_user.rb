class AddWebsocketTokenToUser < ActiveRecord::Migration
  def change
    add_column :users, :websocket_token, :string, :null => false
  end
end
