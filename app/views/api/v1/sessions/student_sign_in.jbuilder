json.root_path(dashboard_student_path)

json.(@resource, :id, :name, :email, :phone_number, :authentication_token)

json.(course_pusher_events, *course_pusher_events.events)

json.courses @resource.profile.courses do |course|

  json.(course, :id, :uuid, :name, :start_date, :end_date, :channel)
  json.teacher(course.teacher, :id, :name, :email)

  json.events course.events do |event|
    json.(event, :uuid, :start_at, :end_at, :status, :channel)

    json.(event_pusher_events, *event_pusher_events.events)

    json.timeline do
      json.(event.timeline, :id, :start_at)
      json.messages event
        .timeline
        .timeline_interactions
        .messages
        .map(&:interaction) do |message|
          json.(message, :id, :content, :created_at)
          json.up_votes(message.get_upvotes.count)
          json.down_votes(message.get_downvotes.count)
        end
    end

  end

end
