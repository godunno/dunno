json.(comment, :event_start_at, :body, :created_at)
json.user do
  json.name comment.profile.name
  json.avatar_url comment.profile.avatar_url
  json.id comment.profile.user.id
end
