class FindOrInitializeEvent
  attr_reader :course, :start_at

  def self.by(course, attributes)
    new(course, attributes).find
  end

  def initialize(course, attributes)
    @course     = course
    attributes = attributes.with_indifferent_access
    @start_at   = attributes.delete('start_at').to_time
  end

  def find
    event = course.events.by_start_at(start_at)
    return event if event.present?
    course.events.build(start_at: start_at).tap do |event|
      return event if event.persisted?
      service = FindWeeklySchedule.new(event.start_at, course.weekly_schedules)
      return event unless service.weekly_schedule?
      event.classroom ||= service.classroom
      event.end_at ||= service.end_at
    end
  end
end
