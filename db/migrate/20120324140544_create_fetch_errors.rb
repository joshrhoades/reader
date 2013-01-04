class CreateFetchErrors < ActiveRecord::Migration
  def change
    create_table :fetch_errors do |t|
      t.references :feed
      t.string :http_status
      t.string :message

      t.timestamps
    end
  end
end
