json.(comment, :id, :body, :event_start_at, :created_at)
json.user do
  json.name comment.profile.name
  json.avatar_url comment.profile.avatar_url
  json.id comment.profile.user.id
end
