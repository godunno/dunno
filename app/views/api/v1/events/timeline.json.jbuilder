json.event do
  json.partial! 'models/event', event: @event, pusher_events: StudentPusherEvents.new
end
