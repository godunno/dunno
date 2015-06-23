json.(event, :id, :uuid, :order, :status)
json.formatted_status(event.formatted_status(current_profile))
json.start_at(format_time(event.start_at))
json.end_at(format_time(event.end_at))
json.formatted_classroom([event.course.class_name, event.classroom].compact.join(' - '))
