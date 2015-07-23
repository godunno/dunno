class FindOrInitializeEvent
  attr_reader :course

  def initialize(course)
    @course = course
  end

  def by(attributes, order)
    course.events.find_or_initialize_by(attributes).tap do |event|
      event.order = order
      return event if event.persisted?
      service = FindWeeklySchedule.new(event.start_at, course.weekly_schedules)
      event.classroom ||= service.classroom
      event.end_at ||= service.end_at
    end
  end
end
