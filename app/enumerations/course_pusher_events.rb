class CoursePusherEvents

  EVENTS = {
    open_event: "open_event"
  }

  STUDENT_EVENTS = [:open_event]
  TEACHER_EVENTS = []

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
