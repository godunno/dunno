json.array! @events do |event|
  json.partial! 'api/v1/events/event', event: event
  json.course do
    json.partial! 'api/v1/courses/course', course: event.course
  end
  if event.published?
    json.topics event.topics.without_personal, partial: 'api/v1/topics/topic', as: :topic
  else
    json.topics []
  end
end
