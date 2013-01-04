require 'spec_helper'

describe Entry do

  let(:entry)                { Entry.new guid: "123", url: "http://www.example.com/", feed: feed,
                                             published_at: Date.current }
  let(:feed)                 { Feed.create! name: "Feed 1", feed_url: "http://www.example.com/foo.rss",
                                            site_url: "http://www.example.com/" }

  before :each do

  end

  describe "embeds" do
    pending
    it "" do
      entry.content = <<END
<p></p>
END

    end
  end

end