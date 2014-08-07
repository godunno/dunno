json.(@resource, :id, :name, :email, :avatar, :authentication_token)

json.courses @resource.courses do |course|
  json.(course, :uuid, :channel)
  json.events course.events do |event|
    json.(event, :uuid, :start_at, :end_at, :status, :channel)
    json.(event_pusher_events, *event_pusher_events.events)
  end
end
