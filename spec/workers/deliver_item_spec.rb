require 'spec_helper'

describe DeliverItem do

  let(:user)  { User.create! name: "Bob", email: "bob@example.com", password: '123456' }
  let(:item)  { Item.create! user: user, entry: entry }
  let(:entry) { Entry.create! guid: "123", url: "http://www.example.com/", feed: feed, published_at: Date.current }
  let(:feed)  { Feed.create! name: "Feed 1", feed_url: "http://www.example.com/foo.rss", site_url: "http://www.example.com/" }

  describe "#perform" do
    it "doesn't throw an error" do
      DeliverItem.new.perform(item.id, user.id)
    end

  end

end