json.event do
  json.partial! 'models/event', event: @event, show_course: true
end
