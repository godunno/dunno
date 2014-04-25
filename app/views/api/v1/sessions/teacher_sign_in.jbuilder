json.(@resource, :id, :name, :email, :avatar, :authentication_token)

json.courses @resource.courses do |course|
  json.(course, :uuid, :channel)
  json.events course.events do |event|
    json.(event, :uuid, :start_at, :status, :duration,
         :channel)
    json.(pusher_events, *pusher_events.events)
  end
end
