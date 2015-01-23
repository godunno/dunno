json.array! @events do |event|
  EventBuilder.new(event).build!(
    json,
    show_topics: true,
    show_course: true
  )
end
