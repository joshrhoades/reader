namespace :reader do
  desc "get rss documents for testing"
  task :xmls => :environment do
    Feed.find_each do |feed|
      begin
        conn = Faraday.new(:url => feed.feed_url) do |c|
          c.response :follow_redirects
          c.adapter Faraday.default_adapter
        end
        response = conn.get

        if response.status == 200
          if response.body && response.body.present?
            body = response.body.ensure_encoding('UTF-8', :external_encoding  => :sniff, :invalid_characters => :transcode)
            s = Nokogiri::XML(body).to_s

            File.open("#{Rails.root}/tmp/xmls/#{feed.feed_url.parameterize}.xml", "w") do |file|
              file.write(s)
              file.close
            end
          end
        end
      rescue

      end


    end
  end
end