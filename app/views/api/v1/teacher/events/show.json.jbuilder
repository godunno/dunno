json.partial! 'api/v1/events/event', event: @event

json.course do
  json.partial! 'api/v1/courses/course', course: @event.course
end

json.topics @event.topics, partial: 'api/v1/topics/topic', as: :topic

json.previous do
  if @event.previous.present?
    json.partial! 'api/v1/events/event', event: @event.previous
    json.topics @event.previous.topics, partial: 'api/v1/topics/topic', as: :topic
  end
end

json.next do
  if @event.next.present?
    json.partial! 'api/v1/events/event', event: @event.next
    json.topics @event.next.topics, partial: 'api/v1/topics/topic', as: :topic
  end
end
