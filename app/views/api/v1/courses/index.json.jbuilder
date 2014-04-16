json.array! @courses do |course|
  CourseBuilder.new(course).
    build!(json, show_events: true, pusher_events: pusher_events)
end
