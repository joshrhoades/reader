class CreateEntryGuids < ActiveRecord::Migration
  def change
    create_table :entry_guids do |t|
      t.integer :feed_id
      t.string :guid
    end
    add_index :entry_guids, ["feed_id", "guid"], :unique => true,     :name => "feed_id_guid"
  end
end
