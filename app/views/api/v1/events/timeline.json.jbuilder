json.event do
  EventBuilder.new(@event).build!(json, show_course: true, pusher_events: pusher_events)
end
