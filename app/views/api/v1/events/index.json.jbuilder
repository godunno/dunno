json.array! @events do |event|
  json.partial! 'models/event', event: event
end

