class ProcessEntry
  include Sidekiq::Worker
  sidekiq_options :queue => :entry
  def perform(feed_id, content, summary, entry_id, url, published, updated, title, author)
    Feeder::EntryProcessor.process_entry(feed_id, content, summary, entry_id, url, published, updated, title, author)
  end
end
