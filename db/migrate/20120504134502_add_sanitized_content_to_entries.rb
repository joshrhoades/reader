class AddSanitizedContentToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :sanitized_content, :text
  end
end
