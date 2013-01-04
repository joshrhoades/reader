class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.references :user
      t.references :feed
      t.references :group

      t.string :name

      t.timestamps
    end
  end
end
