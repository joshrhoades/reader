class FeedIcon < ActiveRecord::Base
  mount_uploader :feed_icon, FeedIconUploader

  def local_path
    self.feed_icon.url
    #self.uri
  end
end
