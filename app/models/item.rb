class ItemValidator < ActiveModel::Validator
  def validate(record)
    user_id = record.user_id
    entry_id = record.entry_id
    c = Item.where(:user_id => user_id).where(:entry_id => entry_id).count
    if c >= 1 && record.id.nil?
      record.errors[:base] = "Already delivered"
    end
  end
end

class Item < ActiveRecord::Base
  belongs_to :user
  belongs_to :from, :class_name => "User"
  belongs_to :entry
  belongs_to :subscription
  has_many :comments, :dependent => :destroy

  after_update :update_children
  after_update :share_item, :unless => :share_delivered?
  after_update :unshare_item, :if => :share_delivered?

  after_commit :update_subscription_count

  before_destroy :revoke_item

  belongs_to :parent, :class_name => "Item"
  has_many :children, :class_name => "Item", :foreign_key => :parent_id
  has_one :feed, :through => :subscription

  validates_with ItemValidator

  default_scope {
    includes(:entry).includes(:comments).includes(:feed)
  }

  scope :for, lambda { |user_id|
     where("user_id = ?", user_id)
  }

  scope :filter, lambda { |filter|
    unless filter == "all"
      where("#{filter} = ?", true)
    end
  }

  def share_item
    if self.shared and !self.share_delivered?
      ShareItem.perform_async self.id
    end
  end

  def unshare_item
    if !self.shared and self.share_delivered?
      UnshareItem.perform_async self.id
    end
  end

  def revoke_item
    RevokeItem.perform_async self.id, self.user_id
  end

  def update_children
    if self.has_new_comments?
      UpdateDownstreamItem.perform_async self.id
    end
  end

  def all_comments
    parent_comments + comments
  end

  def parent_comments
    parent.try(:all_comments) || []
  end

  #def feed_id
  #  self.subscription.feed.id unless self.subscription.nil?
  #end

  def self.batch_mark_read(ids)
    # half assed attempt at preventing a sql injection
    unless ids.nil?
      _ids = ids.collect do |id|
        id.to_i.to_s
      end
      self.where("id IN (#{_ids.join(',')})").all.each do |item|
        item.unread = false
        item.save
      end
    end
  end

  def update_subscription_count
    subscription.update_counts if subscription && subscription.user == self.user
  end


end

