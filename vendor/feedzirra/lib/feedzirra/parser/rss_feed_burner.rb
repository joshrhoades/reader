module Feedzirra

  module Parser
    # Parser for dealing with RSS feeds.
    class RSSFeedBurner
      include SAXMachine
      include FeedUtilities
      element :title
      element :description
      element :link, :as => :url
      elements :item, :as => :entries, :class => RSSFeedBurnerEntry
      element 'atom10:link', :value => :href , :as => :hub, :with => {:rel => "hub"}
      element 'atom10:link', :value => :href , :as => :self, :with => {:rel => "self"}
      attr_accessor :feed_url

      def self.able_to_parse?(xml) #:nodoc:
        (/\<rss|\<rdf/ =~ xml) && (/feedburner/ =~ xml)
      end
    end

  end

end