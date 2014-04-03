json.(@resource, :id, :name, :email, :avatar, :authentication_token)

json.courses @resource.courses do |course|
  json.(course, :uuid)
  json.events course.events do |event|
    json.(event, :uuid, :start_at, :status, :duration,
         :channel)
    pusher_events = TeacherPusherEvents.new
    json.(pusher_events, *pusher_events.events)
  end
end
