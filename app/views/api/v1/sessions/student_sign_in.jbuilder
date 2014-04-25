json.(@resource, :id, :name, :email, :avatar, :authentication_token)

json.courses @resource.courses do |course|

  json.(course, :id, :uuid, :name, :weekdays, :start_date, :start_time, :end_date, :end_time, :channel)
  json.teacher(course.teacher, :id, :name, :email)

  json.events course.events do |event|
    json.(event, :uuid, :title, :start_at, :status, :duration,
          :channel)

    json.(pusher_events, *pusher_events.events)

    json.timeline do
      json.(event.timeline, :id, :start_at)
      json.messages event.timeline.timeline_interactions.messages.map(&:interaction) do |message|
        json.(message, :id, :content, :created_at)
        json.up_votes(message.up_votes.count)
        json.down_votes(message.down_votes.count)
      end
    end

  end

end

