json.(@event, :id, :uuid, :start_at, :end_at, :status, :channel)

json.(event_pusher_events, *event_pusher_events.events)

json.thermometers(@event.thermometers, :uuid, :content)

json.topics @event.topics do |topic|
  TopicBuilder.new(topic).build!(json)
end

json.polls @event.polls do |poll|
  PollBuilder.new(poll).build!(json)
end

json.timeline do
  TimelineBuilder.new(@event.timeline).build!(json, voter: current_student)
end
