class TeacherPusherEvents

  EVENTS = {
    close_event: "close",
    release_poll_event: "release_poll"
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
