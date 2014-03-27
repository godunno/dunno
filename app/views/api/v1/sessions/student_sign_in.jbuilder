json.(@resource, :id, :name, :email, :avatar, :authentication_token)

json.events @resource.events do |event|
  json.(event, :uuid, :title, :start_at, :status, :duration,
       :channel, :student_message_event, :up_down_vote_message_event,
       :release_poll_event, :receive_rating_event)

  json.timeline do
    json.(event.timeline, :id, :start_at)
    json.messages event.timeline.timeline_interactions.messages.map(&:interaction) do |message|
      json.(message, :id, :content, :created_at)
    end
  end

  json.course do
    json.(event.course, :id, :uuid, :name, :weekdays, :start_date, :start_time, :end_date, :end_time)
    json.teacher(event.course.teacher, :id, :name, :email)
  end
end
