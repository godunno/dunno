json.events do
  json.array! @events do |event|
    json.partial! 'api/v1/events/event', event: event
    json.topics TopicsFor.new(event, current_profile).topics, partial: 'api/v1/topics/topic', as: :topic
  end
end

json.previous_month(@pagination.previous_month.utc.iso8601)
json.current_month(@pagination.current_month.utc.iso8601)
json.next_month(@pagination.next_month.utc.iso8601)
