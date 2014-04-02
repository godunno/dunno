json.(event, :id, :title, :uuid, :duration, :start_at, :channel, :student_message_event,
           :up_down_vote_message_event, :release_poll_event, :receive_rating_event, :status)
json.course do
  json.partial! 'models/course', course: event.course
end

json.timeline do
  json.partial! 'models/timeline', timeline: event.timeline
end
