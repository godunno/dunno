json.course do
  json.partial! 'api/v1/courses/course', course: @course
  role = current_profile.role_in(@course)
  json.events @events do |event|
    json.cache! ['course-show/event', @course, event.start_at, event.updated_at, role] do
      json.(event, :classroom)
      json.formatted_status(event.formatted_status(current_profile))
      json.start_at(format_time event.start_at)
      json.end_at(format_time event.end_at)
    end
  end
  json.previous_month(@pagination.previous_month.utc.iso8601)
  json.current_month(@pagination.current_month.utc.iso8601)
  json.next_month(@pagination.next_month.utc.iso8601)
end
