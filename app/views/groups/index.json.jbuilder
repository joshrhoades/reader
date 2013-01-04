
json.array! @groups do |group|
  json.(group, :id, :user_id, :label, :key, :open, :weight)
end