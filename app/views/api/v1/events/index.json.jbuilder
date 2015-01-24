json.array! @events do |event|
  EventBuilder.new(event).build!(json, show_course: true)
end
