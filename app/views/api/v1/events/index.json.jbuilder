json.array! @events do |event|
  json.partial! 'models/event', event: event, pusher_events: StudentPusherEvents.new
end

