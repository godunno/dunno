json.(event, :uuid, :status, :classroom)
json.start_at(format_time(event.start_at))
json.end_at(format_time(event.end_at))
