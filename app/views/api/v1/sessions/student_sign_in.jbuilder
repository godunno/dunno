json.(@resource, :name, :email, :avatar, :authentication_token)

json.events @resource.events do |event|
  json.(event, :uuid, :start_at, :status, :duration,
       :channel, :student_message_event, :up_down_vote_message_event,
       :release_poll_event, :receive_rating_event)

  json.timeline do
    json.messages event.timeline.timeline_interactions.messages.map(&:interaction) do |message|
      json.(message, :content)
    end
  end

  json.course do
    json.(event.course, :uuid)
    json.teacher(event.course.teacher, :name)
  end
end
