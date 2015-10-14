json.start_at format_time(notifiable.start_at)
json.course do
  json.(notifiable.course, :name)
end
