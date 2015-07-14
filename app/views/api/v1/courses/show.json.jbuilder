json.course do
  CourseBuilder.new(@course).build!(json, profile: current_profile)
  role = current_profile.role_in(@course)
  json.cache! ['course-show/events', @events.maximum(:updated_at), role] do
    json.events @events do |event|
      json.cache! ['course-show/event', event, role] do
        json.partial! 'api/v1/events/event', event: event
      end
    end
  end
  json.previous_month(@pagination.previous_month.utc.iso8601)
  json.current_month(@pagination.current_month.utc.iso8601)
  json.next_month(@pagination.next_month.utc.iso8601)
end
