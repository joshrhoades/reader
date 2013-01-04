require 'acts_as_follower'
class User < ActiveRecord::Base
  include ActionView::Helpers::SanitizeHelper
  include PossibleContacts

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :token_authenticatable,
    :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :remember_for => 3.months

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :name, :password, :password_confirmation, :remember_me

  acts_as_followable
  acts_as_follower


  after_create :make_root_group, :copy_anonymous_feeds, :send_welcome_email
  before_create :create_websocket_token, :create_public_token
  after_create :create_starred_item_feed, :create_shared_item_feed

  after_commit :sanitize_name

  before_save :ensure_websocket_token
  has_one :facebook_authorization, :dependent => :destroy

  belongs_to :shared_feed, :class_name => "Feed"
  belongs_to :starred_feed, :class_name => "Feed"
  has_one :client, :dependent => :destroy

  has_many :feeds, :through => :subscriptions
  has_many :subscriptions, :dependent => :destroy, :conditions => "deleted = 'f'"
  has_many :deleted_subscriptions, :class_name => "Subscription", :conditions => "deleted = 't'"
  has_many :items, :dependent => :destroy
  has_many :comments, :dependent => :destroy

  has_many :groups, :dependent => :destroy

  def copy_anonymous_feeds
    User.anonymous.subscriptions.each do |sub|
      grp = Group.find_or_create_by_label_and_user_id(sub.group.label, self.id)
      sub2 = Subscription.new(:user_id => self.id, :feed_id => sub.feed.id, :group => grp, :name => sub.feed.name)
      sub2.save
    end
    NewUserSetup.perform_in(2.seconds, id)
  end

  def set_weights
    ap "set weights"
    set_group_weights
    set_subscription_weights
  end

  def set_subscription_weights
    weight = 0
    self.subscriptions.order("weight ASC").each do |sub|
      weight = weight + 100
      sub.update_column :weight, weight
    end
  end

  def set_group_weights
    weight = 0
    self.groups.order("weight ASC").each do |grp|
      weight = weight + 100
      grp.update_column :weight, weight
    end
    self.groups.where("label = ''").each do |grp|
      weight = weight + 100
      grp.update_column :weight, weight
    end
  end

  def create_shared_item_feed
    f = Feed.new
    f.name = "Posts shared by #{self.name}"
    f.feed_url = "http://1kpl.us/user/#{self.public_token}/shared"
    f.site_url = "http://1kpl.us/"
    f.user = self
    f.private = true
    f.fetchable = false
    f.save!
    self.update_column :shared_feed_id, f.id
  end

  def create_starred_item_feed
    f = Feed.new
    f.name = "Posts starred by #{self.name}"
    f.feed_url = "http://1kpl.us/user/#{self.public_token}/starred"
    f.site_url = "http://1kpl.us/"
    f.user = self
    f.private = true
    f.fetchable = false
    f.save!
    self.update_column :starred_feed_id, f.id
  end


  def make_root_group
    Group.create(:user_id => self.id, :label => "")
  end

  def create_public_token
    self.public_token = rand(36**16).to_s(36)
  end
  def create_websocket_token
    self.websocket_token = rand(36**16).to_s(36)
  end

  def ensure_websocket_token
    if self.websocket_token.nil?
      self.websocket_token = rand(36**8).to_s(36)
    end
  end

  def send_welcome_email
    PlusMailer.welcome(self).deliver
  end

  def ensure_token!
    @user.ensure_authentication_token!
  end

  def sanitize_name
    clean_name = sanitize(self.name)
    self.update_column :name, clean_name
  end

  def self.find_for_developer_oauth(access_token, signed_in_resource=nil)
    return unless Rails.env.development?

    data = access_token.info
    if user = User.where(:email => data.email).first
      user
    else # Create a user with a stub password.
      User.create!(:email => data.email, :name => data.name, :password => Devise.friendly_token[0,20])
    end
  end

  def self.find_for_facebook_oauth(access_token)
    data = access_token.extra.raw_info
    if user = User.where(:email => data.email).first
      user
    else # Create a user with a stub password.
      User.create!(:name => data.name, :email => data.email, :password => Devise.friendly_token[0,20])
    end
  end


  def followed_people
    self.all_follows.collect do |f|
      {:id => f.followable_id, :name => User.find(f.followable_id).name}
    end
  end

  def friends
    self.all_following
  end


  def unblock(user)
    Follow.where(:followable_id => self.id).where(:follower_id => user.id).each do |f|
      f.blocked = false
      f.save
    end
  end

  def follow_requests
    Follow.where(:followable_id => self.id).where(:blocked => true).where(:ignored => false).all.map {|f| f.follower }
  end

  def follow_and_unblock(user)
    self.follow user
    user.unblock self
  end

  def ignore_requests_from(user)
    Follow.where(:followable_id => self.id).where(:follower_id => user.id).each do |f|
      f.ignored = true
      f.save
    end
  end

  def subscribe_to_url(url, group=nil)
    Subscription.find_or_create_from_url_for_user(url, self, group)
  end

  def self.anonymous
    User.find_by_email('anonymous@1kpl.com')
  end
  def self.charlie
    User.find_by_email("charliewilkins@gmail.com")
  end
  def self.loren
    User.find_by_email("loren.spector@gmail.com")
  end
  def self.josh
    User.find_by_email("josh@example.com")
  end
  def self.steve
    User.find_by_email("steve@example.com")
  end
end
