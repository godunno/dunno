json.start_at format_time(event.start_at)
json.course do
  json.(event.course, :uuid, :name)
end
