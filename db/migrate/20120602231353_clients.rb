class Clients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.references :user, :null => false
      t.string :client_id, :null => false
      t.string :channel, :null => false
      t.timestamps
    end
  end
end
