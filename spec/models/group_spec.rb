require 'spec_helper'

describe Group do

  let(:other_user)           { User.create! name: "Jane", email: "jane@example.com", password: '123456' }
  let(:other_subscription)   { Subscription.create! user: other_user, feed: feed, name: "User Subscription", group: other_group }
  let!(:other_item)          { Item.create! user: other_user, entry: entry, subscription: other_subscription }
  let(:other_group)          { Group.create! user: other_user, label: "Group 1" }

  let(:user)                 { User.create! name: "Bob", email: "bob@example.com", password: '123456' }
  let(:subscription)         { Subscription.create! user: user, feed: feed, name: "User Subscription", group: group }
  let!(:item)                { Item.create! user: user, entry: entry, subscription: subscription }
  let(:group)                { Group.create! user: user, label: "Group 1" }
  let(:entry)                { Entry.create! guid: "123", url: "http://www.example.com/", feed: feed,
                                             published_at: Date.current }
  let(:feed)                 { Feed.create! name: "Feed 1", feed_url: "http://www.example.com/foo.rss",
                                            site_url: "http://www.example.com/" }

  before :each do

  end

  describe "#subscriptions" do
    it "contains subscriptions belonging to the group" do
      group.subscriptions.should_not include other_subscription
      group.subscriptions.should include subscription
    end
  end

  describe "#items" do
    it "contains items from the subscriptions in the group" do
      group.items.should_not include other_item
      group.items.should include item
    end
  end

end