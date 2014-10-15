class EventPusherEvents
  EVENTS = {
    student_message_event: "student_message",
    up_down_vote_message_event: "up_down_vote_message",
    receive_rating_event: "receive_rating",
    close_event: "close",
    release_poll_event: "release_poll",
    release_media_event: "release_media"
  }

  STUDENT_EVENTS = [:student_message_event, :up_down_vote_message_event, :receive_rating_event, :release_poll_event, :release_media_event, :close_event]
  TEACHER_EVENTS = [:student_message_event, :up_down_vote_message_event]

  def initialize(user)
    @profile = user.profile
  end

  EVENTS.each do |event, value|
    define_method event do
      value
    end
  end

  def events
    case @profile
    when Student then STUDENT_EVENTS
    when Teacher then TEACHER_EVENTS
    end
  end
end
