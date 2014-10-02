EventBuilder.new(@event).build!(
  json,
  personal_notes: true,
  event_pusher_events: event_pusher_events,
  show_course: true
)
