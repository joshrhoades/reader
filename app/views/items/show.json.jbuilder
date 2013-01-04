json.(@item, :id, :user_id, :subscription_id, :unread, :starred, :shared, :commented, :created_at, :updated_at, :entry_id)
json.comments @item.all_comments do |comment|
  json.(comment, :id, :user_id, :body, :html, :item_id, :created_at)
  json.name comment.user.name
end