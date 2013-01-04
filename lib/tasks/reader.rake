namespace :reader do

  namespace :feeder do
    desc "reset feed error counts"
    task :reset => :environment do
      Feed.update_all parse_errors: 0, timeouts: 0, fetchable: true, etag: nil, hub: nil, topic: nil
    end

    desc "poll feeds for new posts"
    task :run => :environment do
      Feeder::Base.run!
    end

    desc "poll feeds for new posts"
    task :unsubscribe => :environment do
      Feeder::Base.unsubscribe_all!
    end
  end

  desc "test embed.ly"
  task :test_embedly => :environment do
    TestEmbedly.new
  end

  desc "fix entries without published_at dates"
  task :fix_entry_published_dates => :environment do
    Entry.where(published_at: nil).find_each do |e|
      e.published_at = e.created_at
      e.save!
    end
  end

  desc "fetch feed favicons"
  task :icons => :environment do
    Feed.all.each do |f|
      f.get_icon
    end
  end

  desc "prune old entries and items that are no longer needed"
  task :prune => :environment do
    Reader::Setup.prune
  end

  desc "update anonymous user feeds"
  task :anonymous => :environment do
    Reader::Setup.update_anon_feeds
  end

  desc "seed application"
  task :seed => :environment do
    Reader::Setup.seed
  end

  desc "scrub application"
  task :scrub => :environment do
    Entry.destroy_all
    Item.destroy_all
    EntryGuid.destroy_all
    FeedIcon.destroy_all
    Comment.destroy_all
    Client.destroy_all
    `rm -rf public/uploads/*`
  end

  desc "reset fetchable, parse errors, timeouts"
  task :feed_reset_errors => :environment do
    Feed.all.each do |f|
      f.fetchable = true
      f.timeouts = 0
      f.parse_errors = 0
      f.save
    end
  end

  desc "### TEST: Marks all items read but one for each subscription"
  task :all_but_one => :environment do
    Item.update_all unread: false
    User.charlie.subscriptions.each do |sub|
      item = sub.items.first
      item.update_column(:unread, true) if item
    end
    Subscription.update_counts
  end

  desc "init EntryGuids"
  task :init_entry_guids => :environment do
    Entry.all.each do |entry|
      eg = EntryGuid.find_or_initialize_by_feed_id_and_guid(entry.feed_id, entry.guid)
      if eg.new_record?
        eg.save
      end
    end
  end


end

