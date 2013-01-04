class AddIgnoredToFollows < ActiveRecord::Migration
  def change
    add_column :follows, :ignored, :boolean, :default => false
  end
end
