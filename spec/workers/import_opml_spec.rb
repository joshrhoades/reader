require 'spec_helper'

describe ImportOpml do

  let(:user)     { User.create! name: "Bob", email: "bob@example.com", password: '123456' }
  let(:filetext) { File.open("spec/support/fixtures/subscriptions.xml").read }

  describe "#perform" do
    it "doesn't explode" do
      VCR.use_cassette('import opml worker', :record => :new_episodes) do
        ImportOpml.new.perform(filetext, user.id)
      end
      Feed.count.should == 101 # Includes the shared & starred feeds for anon and bob (4 feeds).
      Subscription.count.should == 97
    end

  end

end