json.event do
  json.partial! 'api/v1/system_notifications/event', notifiable: notifiable.event
end
