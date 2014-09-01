json.(@resource, :id, :name, :email, :authentication_token)

json.courses @resource.profile.courses do |course|
  json.(course, :uuid, :channel)
  json.events course.events do |event|
    json.(event, :uuid, :start_at, :end_at, :status, :channel)
    json.(event_pusher_events, *event_pusher_events.events)
  end
end
