
json.array! @comments do |comment|
  json.(comment, :id, :user_id, :item_id, :body, :html, :created_at)
  json.(comment.user, :name)
end

