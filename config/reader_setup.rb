module Reader
  module Keys
    SMTP_PASS = '12345'

    FACEBOOK_API_KEY = '12345'
    FACEBOOK_SECRET  = '12345'

    GOOGLE_API_KEY = '12345'
    GOOGLE_SECRET  = '12345'


  end

  class Setup
    def self.users
      users = User.count
      if users == 0
        u = User.new
        u.name = "Anonymous 1kpl.us User"
        u.email = "anonymous@1kpl.com"
        u.password = '12345'
        u.password_confirmation = '12345'
        u.anonymous = true
        u.save :validate => false

        u = User.new
        u.name = "Charlie Wilkins"
        u.email = "charliewilkins@gmail.com"
        u.password = '12345'
        u.password_confirmation = '12345'
        u.save :validate => false

        u = User.new
        u.name = "Loren Spector"
        u.email = "loren.spector@gmail.com"
        u.password = '12345'
        u.password_confirmation = '12345'
        u.save :validate => false

        u = User.new
        u.name = "Josh Rhoades"
        u.email = "josh@example.com"
        u.password = '12345'
        u.password_confirmation = '12345'
        u.save :validate => false

        u = User.new
        u.name = "Steve Polk"
        u.email = "steve@example.com"
        u.password = '12345'
        u.password_confirmation = '12345'
        u.save :validate => false
      end
    end

    def self.scrub
      return unless Rails.env.development?
      self.empty_tables

      self.reset_auto_increment

    end

    def self.seed
      return unless Rails.env.development?

      self.empty_tables

      self.reset_auto_increment

      if User.count == 0
        Reader::Setup.users
        Reader::Setup.update_anon_feeds
      end


      users = User.where(:anonymous => false).all
      users.each do |user|
        #feed_urls = File.readlines("spec/good_urls.txt").collect {|line| line}
        #feed_urls = feed_urls.sample 100
        #
        #feed_urls.each {|fu| Subscription.find_or_create_from_url_for_user(fu,user)}
        #
        #subscriptions = Subscription.where(:user_id => user.id).all
        #subscriptions.each do |sub|
        #  groups = Group.where(:user_id => user.id).all
        #  group = groups.sample
        #  sub.group = group
        #  sub.save
        #end
      end

      unless User.charlie.nil?
        user = User.charlie

        feed_urls = File.readlines("spec/good_urls.txt").collect {|line| line}
        feed_urls = feed_urls.sample 100

        feed_urls.each {|fu| Subscription.find_or_create_from_url_for_user(fu,user)}

        subscriptions = Subscription.where(:user_id => user.id).all
        subscriptions.each do |sub|
          groups = Group.where(:user_id => user.id).all
          group = groups.sample
          sub.group = group
          sub.save
        end

        grp = Group.find_or_create_by_label_and_user_id "Ruby", user.id
        feed_urls = File.readlines("spec/ruby_urls.txt").collect {|line| line}
        feed_urls.each {|fu| Subscription.find_or_create_from_url_for_user(fu,user,grp)}
      end



      User.charlie.follow_and_unblock User.loren
      User.loren.follow_and_unblock User.charlie
      User.loren.follow_and_unblock User.josh
      User.josh.follow_and_unblock User.loren
      User.josh.follow_and_unblock User.steve



    end

    def self.reset_auto_increment
      # conn = User.connection
      # conn.tables.each do |t|
      #   conn.execute("select setval('#{t}_id_seq', 1453);")
      # end
    end

    def self.delete_icons
      `rm -rf public/uploads/*`
    end

    def self.empty_tables
      User.delete_all
      Client.delete_all
      Feed.delete_all
      Entry.delete_all
      Subscription.delete_all
      Category.delete_all
      CategoryEntryMapping.delete_all
      FacebookAuthorization.delete_all
      FeedIcon.delete_all
      Comment.delete_all
      FacebookContact.delete_all
      FetchError.delete_all
      Follow.delete_all
      Group.delete_all
    end

    def self.update_anon_feeds
      user = User.where(:anonymous => true).first

      user.subscriptions.each do |sub|
        sub.destroy
      end
      user.items.each do |item|
        item.delete
      end

      grp = Group.find_or_create_by_label_and_user_id "", user.id

      feed_urls = File.readlines("spec/anon_urls.txt").collect {|line| line}

      feed_urls.each do |fu|
        if fu =~ /^group:/
          grp = Group.find_or_create_by_label_and_user_id fu.sub('group:', ''), user.id
        else
          Subscription.find_or_create_from_url_for_user(fu,user,grp)
        end
      end
    end

    def self.prune
      users = User.where(:sign_in_count => 0)
      puts "#{users.length} users to delete"
      users.each do |u|
        puts "Old User: #{u.name}"
        u.destroy
      end

      items = Item.where("unread = false AND starred = false AND shared = false AND has_new_comments = false").where("created_at < ?", Date.current - 3.months)
      puts "#{items.length} items to delete"
      items.find_each do |i|
        if i.comments.empty?
          i.destroy
        end
      end

      Item.find_each do |i|
        i.destroy if i.entry.nil?
      end

      Feed.find_each do |f|
        unless f.private
          if f.subscriptions.empty?
            puts "destroy #{f.name}"
            f.destroy
          end
        end
      end

      entries = []
      Entry.find_each do |e|
        if e.items.empty?
          entries << e
        end
      end
      puts "#{entries.length} entries to delete"
      entries.each do |e|
        e.destroy
      end



      Follow.find_each do |f|
        if f.follower.nil?
          puts "follower is nil"
        end
        if f.followable.nil?
          puts "followable is nil"
        end
      end
    end

  end


end