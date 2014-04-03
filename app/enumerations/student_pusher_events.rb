class StudentPusherEvents
  EVENTS = {
    student_message_event: "student_message",
    up_down_vote_message_event: "up_down_vote_message",
    receive_rating_event: "receive_rating",
  }

  EVENTS.each do |event, value|
    define_method event do
      value
    end
  end

  def events
    EVENTS.keys
  end
end
