json.course do
  CourseBuilder.new(@course).build!(json, show_students: true)
  json.cache! ['course-builder-events', @events.maximum(:updated_at)] do
    json.events @events do |event|
      json.cache! ['course-builder-event', event] do
        EventBuilder.new(event).build!(json, show_course: false)
      end
    end
  end
  json.previous_month((@day - 1.month).utc.beginning_of_month.iso8601)
  json.current_month(@day.utc.beginning_of_month.iso8601)
  json.next_month((@day + 1.month).utc.beginning_of_month.iso8601)
end
