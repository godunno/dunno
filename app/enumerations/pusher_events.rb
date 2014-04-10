class PusherEvents

  EVENTS = {
    student_message_event: "student_message",
    up_down_vote_message_event: "up_down_vote_message",
    receive_rating_event: "receive_rating",
    release_poll_event: "release_poll",
    release_media_event: "release_media",
    close_event: "close",
    open_event: "open",
  }


  STUDENT_EVENTS = [:student_message_event, :up_down_vote_message_event, :receive_rating_event, :release_poll_event, :release_media_event, :close_event, :open_event]
  TEACHER_EVENTS = [:student_message_event, :up_down_vote_message_event]

  def initialize(user)
    @user = user
  end

  EVENTS.each do |event, value|
    define_method event do
      value
    end
  end

  def events
    case @user
    when Student then STUDENT_EVENTS
    when Teacher then TEACHER_EVENTS
    end
  end
end
