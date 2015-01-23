EventBuilder.new(@event).build!(
  json,
  show_topics: { show_media: true },
  show_personal_notes: { show_media: true },
  show_course: true,
  show_neighbours: true
)
