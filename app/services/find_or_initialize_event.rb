class FindOrInitializeEvent
  attr_reader :course, :order, :start_at

  def self.by(course, attributes)
    new(course, attributes).find
  end

  def initialize(course, attributes)
    @course     = course
    attributes = attributes.with_indifferent_access
    @order      = attributes.delete('order')
    @start_at   = attributes.delete('start_at').to_time
  end

  def find
    course.events.find_or_initialize_by(start_at: start_at).tap do |event|
      event.order = order
      return event if event.persisted?
      service = FindWeeklySchedule.new(event.start_at, course.weekly_schedules)
      return event unless service.weekly_schedule?
      event.classroom ||= service.classroom
      event.end_at ||= service.end_at
    end
  end
end
