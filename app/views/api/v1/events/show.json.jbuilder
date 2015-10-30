json.partial! 'api/v1/events/event', event: @event

json.course do
  json.partial! 'api/v1/courses/course', course: @event.course
end

json.topics TopicsFor.new(@event, current_profile).topics, partial: 'api/v1/topics/topic', as: :topic
json.comments do
  json.array! @event.comments do |comment|
    json.partial! 'api/v1/comments/comment', comment: comment
  end
end

json.previous do
  if @previous.present?
    json.partial! 'api/v1/events/event', event: @previous
    json.topics TopicsFor.new(@previous, current_profile).topics, partial: 'api/v1/topics/topic', as: :topic
  end
end

json.next do
  if @next.present?
    json.partial! 'api/v1/events/event', event: @next
    json.topics TopicsFor.new(@next, current_profile).topics, partial: 'api/v1/topics/topic', as: :topic
  end
end
