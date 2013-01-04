class CreateFeeds < ActiveRecord::Migration
  def change
    create_table :feeds do |t|
      t.string   "name",                           :null => false
      t.references :user
      t.string :feed_url
      t.string :site_url
      t.text     "description"
      t.boolean  "suggested",   :default => false
      t.boolean  "private",   :default => false
      t.datetime "fetched_at"
      t.timestamps
    end
    add_index :feeds, :feed_url
  end
end
