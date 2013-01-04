json.array! @subscriptions do |subscription|
  json.(subscription, :id, :name, :feed_id, :group_id, :icon, :all_count, :unread_count, :starred_count, :shared_count, :commented_count, :weight)

  json.(subscription.feed, :feed_url, :site_url)


end
