require 'open-uri'
require 'timeout'
class FilelessIO < StringIO
  attr_accessor :original_filename
end

class GetIcon
  include Sidekiq::Worker
  sidekiq_options :queue => :icons
  def perform(id)
    feed = Feed.where(id: id).first
    return unless feed
    icon_url = get_favicon feed.site_url

    unless icon_url.nil?
      fi = FeedIcon.create(:feed_id => id, :uri => icon_url)
      file = open fi.uri, :read_timeout => 10

      unless file.respond_to? :original_filename
        file = FilelessIO.new(file.readlines.join)
        file.original_filename = "favicon.ico"
      end

      fi.feed_icon = file
      fi.save!
      feed.update_column :feed_icon_id, fi.id
    end
  rescue
  end

  def get_favicon(site_url)
    unless site_url.nil?
      html = nil
      begin
        Timeout::timeout(5) do
          html = Pismo::Document.new(site_url)
        end
      rescue
        #puts "pismo error - #{site_url}"
      end
      unless html.nil? || html.favicon.nil?
        if test_favicon(html.favicon)
          return html.favicon
        end
        return get_root_favicon
      end
      get_root_favicon
    end
  end

  def create_icon(url)
    FeedIcon.create(:feed_id => id, :uri => url)
  end

  def get_root_favicon
    begin
      uri = URI(site_url)
      ico = uri.scheme + "://" + uri.host + "/favicon.ico"
      if test_favicon(ico)
        return ico
      end
      #png = uri.scheme + "://" + uri.host + "/favicon.png"
      #if test_favicon(png)
      #  return png
      #end
      #gif = uri.scheme + "://" + uri.host + "/favicon.gif"
      #if test_favicon(gif)
      #  return gif
      #end
      return nil
    rescue
      return nil
    end
  end

  def test_favicon(url)
    begin
      status = Timeout::timeout(5) do
        r = open url
        if r.status[0] == '200'
          true
        else
          false
        end
      end
    rescue OpenURI::HTTPError => e
      Rails.logger.error e
      false
    rescue Timeout::Error => e
      Rails.logger.error e
      false
    end
  end

end
