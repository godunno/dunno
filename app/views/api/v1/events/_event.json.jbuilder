json.(event, :id, :uuid, :status, :classroom)
json.formatted_status(event.formatted_status(current_profile))
json.start_at(format_time(event.start_at))
json.end_at(format_time(event.end_at))
