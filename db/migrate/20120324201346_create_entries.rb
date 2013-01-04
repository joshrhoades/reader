class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.string :guid
      t.references :feed
      t.text :title
      t.string :url, :null => false, :limit => 4096
      t.string :author
      t.text :summary
      t.text :content
      t.datetime :published_at

      t.timestamps
    end
    add_index :entries, :guid
    add_index :entries, :url
    add_index :entries, :feed_id
  end
end
