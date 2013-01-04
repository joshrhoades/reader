class Comment < ActiveRecord::Base
  include ActionView::Helpers::SanitizeHelper
  include Embedder
  validates_presence_of :body, :item_id, :user_id
  attr_accessible :body, :edited, :item_id, :user_id
  belongs_to :item
  belongs_to :user
  before_save :format_body
  before_create :find_target_item
  after_create :deliver
  before_destroy :revoke
  after_update :refresh

  def find_target_item
    target = self.item
    until target.parent.nil?
      target = target.parent
    end
    self.item_id = target.id

    self.item.update_column :commented, true
  end

  def deliver
    DeliverComment.perform_async self.id
  end

  def revoke
    RevokeComment.perform_async self.id, self.user_id
  end

  def refresh
    UpdateComment.perform_async self.id
  end

  def format_body
    self.html = body.clone
    add_breaks
    self.html = sanitize(self.html)
    self.html = embed_urls(self.html)
  end

  def add_breaks
    self.html.gsub! "\n", "\n<br/>\n"
  end

end
