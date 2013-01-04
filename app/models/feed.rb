class Feed < ActiveRecord::Base
  has_one :feed_icon, :dependent => :destroy
  has_many :subscriptions, :dependent => :destroy
  has_many :entries, :dependent => :destroy
  belongs_to :user
  validates :feed_url, :uniqueness => true

  before_create :set_tokens, :strip_name
  after_create :get_icon, :poll_feed
  scope :fetchable, where(:fetchable => true).where(:private => false)
  #scope :suggested, where(:suggested => true)

  def self.suggested(uid)
    user = User.find uid
    fids = user.subscriptions.pluck(:feed_id)
    feeds = []
    self.where(:suggested => true).all.each do |f|
      feeds << f unless fids.include? f.id
    end
    feeds
  end

  def strip_name
    self.name.strip!
  end

  def set_tokens
    self.token = rand(36**20).to_s(36)
    self.secret_token = rand(36**40).to_s(36)
  end

  def self.get_icons
    find_each do |f|
      f.get_icon
    end
  end

  def get_icon
    GetIcon.perform_async(id) if fetchable? && public?
  end

  def poll_feed
    PollFeed.perform_async(id) if fetchable? && public?
  end

  def push_enabled?
    hub.present? && topic.present?
  end

  def public?
    !private?
  end

end
