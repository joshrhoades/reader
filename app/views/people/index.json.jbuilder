json.array! @people do |person|
  json.(person, :id, :name)

  json.all_count all_count(person)
  json.unread_count unread_count(person)
  json.starred_count starred_count(person)
  json.shared_count shared_count(person)
  json.commented_count commented_count(person)
end
