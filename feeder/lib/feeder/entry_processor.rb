module Feeder
  class EntryProcessor
    def self.process(feed_id, entries, push=false)
      entries.each do |entry|
        process_entry(feed_id, entry.content, entry.summary, entry.entry_id, entry.url, entry.published.to_s, entry.updated.to_s, entry.title, entry.author)
      end
    end

    def self.process_entry(feed_id, content, summary, entry_id, url, published, updated, title, author)
      content = content
      content ||= summary

      guid = entry_id
      guid ||= url

      eg = EntryGuid.find_or_initialize_by_feed_id_and_guid(feed_id, guid)

      entry_date = published || updated
      entry_date = Time.current.to_formatted_s(:db) + " UTC" unless entry_date.present?
      if eg.new_record?
        entry_model = Entry.new(:feed_id => feed_id,
                                :title => title,
                                :author => author,
                                :content => content,
                                :url => url,
                                :guid => guid,
                                :published_at => entry_date)

        entry_model.save!
        eg.save!
      else
        ap "Update Entry"
        entry_model = Entry.where(guid: guid).first
        if entry_model
          entry_model.update_attributes!(:feed_id => feed_id,
                                          :title => title,
                                          :author => author,
                                          :content => content,
                                          :url => url,
                                          :guid => guid,
                                          :published_at => entry_date)
        end
      end


    rescue ActiveRecord::RecordNotUnique => e
      # skip it
    rescue ActiveRecord::RecordInvalid => e
      ap guid
      ap feed_id
    end
  end
end