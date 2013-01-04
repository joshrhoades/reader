class CreateFeedIcons < ActiveRecord::Migration
  def change
    create_table :feed_icons do |t|
      t.references :feed
      t.string :uri

      t.timestamps
    end
  end
end
