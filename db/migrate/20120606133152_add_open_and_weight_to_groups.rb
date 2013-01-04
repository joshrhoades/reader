class AddOpenAndWeightToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :open, :boolean, :default => true
    add_column :groups, :weight, :integer, :default => 0
  end
end
