json.(@resource, :id, :name, :email, :avatar, :authentication_token)

json.courses @resource.courses do |course|
  json.(course, :uuid)
  json.events course.events do |event|
    json.(event, :uuid, :start_at, :status, :duration,
         :channel, :student_message_event, :up_down_vote_message_event,
         :release_poll_event, :receive_rating_event)
  end
end
