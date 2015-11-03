json.(comment, :id, :event_start_at, :created_at, :removed_at)
unless comment.removed?
  json.body(comment.body)
  json.attachments comment.attachments, partial: 'api/v1/attachments/attachment', as: :attachment
end
json.user do
  json.(comment.profile, :id, :name, :avatar_url)
end
