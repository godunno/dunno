json.course do
  CourseBuilder.new(@course).build!(json, show_events: true, event_pusher_events: event_pusher_events)
end
