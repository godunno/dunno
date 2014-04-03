json.(event, :id, :title, :uuid, :duration, :start_at, :channel, :status)

json.(pusher_events, *pusher_events.events)

json.course do
  json.partial! 'models/course', course: event.course
end

json.timeline do
  json.partial! 'models/timeline', timeline: event.timeline
end

json.topics event.topics do |topic|
  json.partial! 'models/topic', topic: topic
end

json.thermometers event.thermometers do |thermometer|
  json.partial! 'models/thermometer', thermometer: thermometer
end

json.polls event.polls do |poll|
  json.partial! 'models/poll', poll: poll
end
