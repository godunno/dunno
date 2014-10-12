class CoursePusher
  attr_reader :event
  delegate :course, to: :event

  def initialize(event)
    @event = event
    @student_pusher_events = CoursePusherEvents.new(User.new(profile: Student.new))
    @teacher_pusher_events = CoursePusherEvents.new(User.new(profile: Teacher.new))
  end

  def open
    trigger(@teacher_pusher_events.open_event, pusher_open_event_json)
  end

  def pusher_open_event_json
    Jbuilder.encode do |json|
      json.(course, :uuid)
      json.event(event, :uuid, :start_at, :end_at)
    end
  end

  private

    def trigger(event_name, content)
      Pusher.trigger(course.channel, event_name, content)
    end
end
