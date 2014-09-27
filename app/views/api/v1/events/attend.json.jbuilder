json.(@event, :id, :uuid, :start_at, :end_at, :status, :channel)

json.(event_pusher_events, *event_pusher_events.events)

json.topics(@event.topics, :id, :description)
json.thermometers(@event.thermometers, :uuid, :content)
json.polls @event.polls do |poll|
  PollBuilder.new(poll).build!(json)
end

json.medias @event.medias do |media|
  MediaBuilder.new(media).build!(json)
end

json.timeline do
  TimelineBuilder.new(@event.timeline).build!(json, voter: current_student)
end


