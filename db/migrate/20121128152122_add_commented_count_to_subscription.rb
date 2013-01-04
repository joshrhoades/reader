class AddCommentedCountToSubscription < ActiveRecord::Migration
  def change
    add_column :subscriptions, :commented_count, :integer
  end
end
