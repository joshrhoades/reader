class AddEntryIndexes < ActiveRecord::Migration
  def change
    add_index :entries, "id", :name => "entries_id"
  end
end
