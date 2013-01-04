require 'spec_helper'

describe User do

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

  describe "#groups" do
    it "contains groups belonging to the user" do
      user.groups.should_not include other_group
      user.groups.should include group
    end
  end

  describe "#subscriptions" do
    it "contains subscriptions belonging to the user" do
      user.subscriptions.should_not include other_subscription
      user.subscriptions.should include subscription
    end
  end

  describe "#items" do
    it "contains items belonging to the user" do
      user.items.should_not include other_item
      user.items.should include item
    end
  end

  describe "#friends" do
    it "returns a list of followed users" do
      user.follow other_user
      other_user.unblock user
      user.friends.should include other_user
      user.friends.should_not include user
    end
  end

  describe "#followers" do
    it "returns a list of users that follow this user" do
      user.follow other_user
      other_user.unblock user
      other_user.followers.should include user
    end
  end

end