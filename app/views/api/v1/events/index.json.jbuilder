json.array! @events do |event|
  EventBuilder.new(event).build!(json, show_course: true, event_pusher_events: event_pusher_events)
end

