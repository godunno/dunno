json.course do
  CourseBuilder.new(@course).build!(json, profile: current_profile)
  role = current_profile.role_in(@course)
  json.events @events do |event|
    json.cache! ['course-show/event', event, role] do
      json.(event, :formatted_status, :formatted_classroom)
      json.order(event[:order])
      json.start_at(format_time(event[:start_at]))
      json.end_at(format_time(event[:end_at]))
    end
  end
  json.previous_month(@pagination.previous_month.utc.iso8601)
  json.current_month(@pagination.current_month.utc.iso8601)
  json.next_month(@pagination.next_month.utc.iso8601)
end
