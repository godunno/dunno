json.course do
  CourseBuilder.new(@course).build!(json, show_teacher: true)
  json.cache! ['course-show/events', @events.maximum(:updated_at)] do
    json.events @events do |event|
      json.cache! ['course-show/event', event] do
        EventBuilder.new(event).build!(json, show_course: false)
      end
    end
  end
  json.previous_month(@pagination.previous_month.utc.iso8601)
  json.current_month(@pagination.current_month.utc.iso8601)
  json.next_month(@pagination.next_month.utc.iso8601)
end
