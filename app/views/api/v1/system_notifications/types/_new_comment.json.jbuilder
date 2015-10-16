json.(notifiable, :id)
json.event do
  json.partial! 'event', event: notifiable.event
end
