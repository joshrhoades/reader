namespace :fixes do
  desc "Fix entries with missing pub date"
  task :fix_pubdate => :environment do
    Entry.where(published_at: nil).all.each { |e| 
    	e.published_at = e.created_at
    	e.save
    }
    Entry.where(published_at: '0000-00-00 00:00:00').all.each { |e| 
    	e.published_at = e.created_at
    	e.save
    }
  end

  desc "Fix facebook auths"
  task :fix_facebook_authorizations => :environment do
    FacebookAuthorization.where(token_expires_at: '0000-00-00 00:00:00').all.each { |e| 
    	e.token_expires_at = Time.now + 1.year
    	e.save
    }
  end
end