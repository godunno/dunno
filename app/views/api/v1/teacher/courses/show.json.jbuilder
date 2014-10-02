json.course do
  CourseBuilder.new(@course).build!(json, personal_notes: true, show_events: true, event_pusher_events: event_pusher_events)
end
