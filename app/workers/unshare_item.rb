class UnshareItem
  include Sidekiq::Worker
  sidekiq_options :queue => :items
  def perform(id)
    item = Item.find id

    item.children.each do |child|
      child.destroy
    end
    item.update_column :share_delivered, false

  end
end