class Entry < ActiveRecord::Base
  include ActionView::Helpers::SanitizeHelper
  include Embedder
  belongs_to :feed
  has_many :category_entry_mappings
  has_many :categories, :through => :category_entry_mappings
  validates_presence_of :guid, :url, :published_at
  validates_uniqueness_of :guid, :scope => :feed_id
  after_create :deliver
  before_save :inline_reddit, :embed_content, :ensure_pubdate, :sanitize_content



  has_many :items, :dependent => :destroy

  def self.share(user, title, body)
    e = Entry.new
    e.author = user.name
    e.content = body
    e.title = title
    e.feed = user.shared_feed
    e.published_at = DateTime.now
    e.parse_share

    e.guid = e.url = "http://1kpl.us/user/#{user.public_token}/shared/#{rand(36**8).to_s(36)}"

    e.save!
  end

  def parse_share
    self.content = self.embed_urls(self.content)
    self.parse_formatting
  end

  def parse_formatting
    repl = '</br>'
    self.content.gsub! /\n/, repl
  end

  def inline_reddit
    if self.feed.feed_url =~ /reddit\.com/
      content = self.content
      url = self.content.match /<a href="([^"]*)">\[link\]/

      imgmatch = url[1].match(/\.(gif|jpg|png|jpeg)(\?|#)*/i) unless url.nil?
      unless imgmatch.nil?
        unless url[1].nil?
          img = "<img src=\"#{url[1]}\" style=\"max-width:95%\"><br/>"
          content = img + self.content
        end
      end
      self.url = url[1]
      self.content = content
    end

    if self.url =~ /\/imgur\.com/
      inline_imgur
    end

    if self.url =~ /\/qkme\.me/
      inline_quickmeme
    end
    if self.url =~ /\/quickmeme\.com/
      inline_quickmeme
    end
  end

  def embed_content
    if Rails.env.production?
      if self.feed.feed_url =~ /reddit\.com/ || self.feed.feed_url =~ /news\.ycombinator\.com\/rss/
        unless url =~ /reddit\.com/ || url =~ /imgur\.com/ || url =~ /qkme\.me/
          self.content = "#{embed_urls(url.dup, false)}<p/>#{self.content}"
        end
      end
    end
  end

  def inline_imgur
    doc = Nokogiri::HTML(open(self.url))
    images = doc.css(".image img")
    chunk = ""
    images.each do |node|
      node.remove_attribute('class')
      chunk += node.to_s.gsub('data-src', 'src')
    end
    self.content = chunk + self.content
  end

  def inline_quickmeme
    doc = Nokogiri::HTML(open(self.url))
    images = doc.css("#img")
    chunk = ""
    images.each do |node|
      node.remove_attribute('class')
      chunk += node.to_s.gsub('data-src', 'src')
    end
    self.content = chunk + self.content
  end

  def ensure_pubdate
    if self.published_at.nil?
      self.published_at = self.created_at
    end
  end

  def pubdate
    # TODO: figure out why some records don't have published at.
    if self.published_at.nil?
      self.published_at = self.created_at
    end
    unless self.published_at.nil?
      self.published_at.to_s :pubdate
    end
  end



  def deliver
    feed = self.feed
    if feed
      subscriptions = feed.subscriptions
      subscriptions.each do |sub|
        item = Item.new(:user_id => sub.user_id, :entry => self, :subscription => sub)
        if item.valid?
          item.save!
        end
      end

      # deliver a copy to sharing user.
      if feed.user && feed.user.shared_feed == feed
        i = Item.new
        i.entry = self
        i.shared = true
        i.unread = false
        i.user = feed.user
        i.from = feed.user
        i.save!
      end
    end
  end

  def deliver_to(user)
    feed = self.feed
    if feed
      subscriptions = Subscription.where(:user_id => user.id).where(:feed_id => feed.id)
      subscriptions.each do |sub|
        item = Item.new(:user_id => sub.user_id, :entry => self, :subscription => sub)

        if item.valid?
          puts "save item"
          item.save
        end
      end
    end
  end

  def add_categories(cats)
    cats.each do |cat|
      catp = cat.parameterize
      category = Category.find_or_create_by_name(catp)
      CategoryEntryMapping.create(:entry_id => self.id, :category_id => category.id)
    end
  end

  def readable
    # TODO: remove this
    Readability::Document.new(content).content
  end

  def base_uri
    site_url = self.feed.site_url
    unless site_url.nil?
      uri = URI.parse(site_url)
      "http://#{uri.host}"
    end
  end

  def site_uri
    self.feed.site_url
  end

  SCRUB = Loofah::Scrubber.new do |node|
    if node.name == "div"
      if node['class'] =~ /feedflare/
        node.remove
      end
    end

    if node.name == "img"
      if node['height'] == '1'
        node.remove
      end

      unless node['src'] =~ /\Ahttp/
        node.remove
      end

      if node.has_attribute? "style"
        node.remove_attribute "style"
      end
      if node.has_attribute? "align"
        node.remove_attribute "align"
      end
      #if node.has_attribute? "class"
      #  node.remove_attribute "class"
      #end
    end

    if node.name == "a"
      if node.has_attribute? "target"
        node.remove_attribute "target"
      end
      node.set_attribute 'target', '_blank'
    end

    #if node.has_attribute? "class"
    #  node.remove_attribute "class"
    #end
    node
  end

  def sanitize_content
    # TODO: Fix broken images with site base uri if possible
    subject = content || ""
    self.title ||= ""
    while subject.match /^<br>/ do
      subject = subject.sub /^<br>/,''
    end

    while subject.match /<table>/ do
      subject = subject.sub /<table>/, '<table class="table">'
    end

    while subject.match /^<p><\/p>/ do
      subject = subject.sub /^<p><\/p>/,''
    end

    subject = subject.gsub /float:\s*(left|right);/,''

    subject = subject.strip

    f = subject.force_encoding("UTF-8")

    #f = Loofah.fragment(f)
    #f = f.scrub!(SCRUB)
    #f = f.scrub!(:prune)

    f = sanitize(f)


    self.sanitized_content = f

    self.title = self.title.force_encoding("UTF-8")
  end





end
