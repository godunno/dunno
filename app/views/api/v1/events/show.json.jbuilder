json.partial! 'api/v1/events/event', event: @event

json.course do
  json.partial! 'api/v1/courses/course', course: @event.course
end

json.topics @event.topics, partial: 'api/v1/topics/topic', as: :topic
json.comments @event.comments, partial: 'api/v1/comments/comment', as: :comment

json.previous do
  if @previous.present?
    json.partial! 'api/v1/events/event', event: @previous
    json.topics @previous.topics, partial: 'api/v1/topics/topic', as: :topic
  end
end

json.next do
  if @next.present?
    json.partial! 'api/v1/events/event', event: @next
    json.topics @next.topics, partial: 'api/v1/topics/topic', as: :topic
  end
end
