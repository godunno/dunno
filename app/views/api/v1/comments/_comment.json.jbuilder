json.(comment, :id, :event_start_at, :created_at, :removed_at)
unless comment.removed?
  json.body(comment.body)
  json.attachments comment.attachments, partial: 'api/v1/attachments/attachment', as: :attachment
end
json.user do
  json.name comment.profile.name
  json.avatar_url comment.profile.avatar_url
  json.id comment.profile.user.id
end
