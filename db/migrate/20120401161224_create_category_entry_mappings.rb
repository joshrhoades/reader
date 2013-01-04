class CreateCategoryEntryMappings < ActiveRecord::Migration
  def change
    create_table :category_entry_mappings do |t|
      t.integer :entry_id
      t.integer :category_id

      t.timestamps
    end
  end
end
