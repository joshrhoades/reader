
json.array! @items do |item|
  if item.entry
    json.(item, :id, :user_id, :subscription_id, :unread, :starred, :shared, :commented, :entry_id)
    json.(item, :from_id, :parent_id, :created_at, :updated_at)
    json.(item, :has_new_comments)
    json.feed_id item.feed.id if item.feed

    json.(item.entry, :title, :author, :url, :published_at)
    json.content item.entry.sanitized_content.to_s
    json.formatted_published_at item.entry.pubdate

    json.comments item.all_comments do |comment|
      json.(comment, :id, :user_id, :body, :html, :item_id, :created_at)
      json.name comment.user.name
    end
  end
end