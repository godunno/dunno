class FindOrInitializeEvent
  attr_reader :course

  def initialize(course)
    @course = course
  end

  def by(attributes, order)
    course.events.find_or_initialize_by(attributes).tap do |event|
      event.order = order
      service = FindWeeklySchedule.new(event.start_at, course.weekly_schedules)
      next unless service.weekly_schedule?
      event.classroom ||= service.classroom
      event.end_at ||= service.end_at
    end
  end
end
