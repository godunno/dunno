class CoursePusherEvents

  EVENTS = {
    open_event: "open_event"
  }

  STUDENT_EVENTS = [:open_event]
  TEACHER_EVENTS = []

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
