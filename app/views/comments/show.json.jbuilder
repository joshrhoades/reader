json.(@comment, :id, :user_id, :item_id, :body, :html, :created_at)
json.(@comment.user, :name)