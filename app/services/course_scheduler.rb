class CourseScheduler
  attr_reader :course, :schedule, :time_range, :current_month
  delegate :weekly_schedules, to: :course

  def initialize(course, time_range)
    @course = course
    @time_range = time_range
    set_schedule
  end

  def events
    return [] if time_range.begin.nil? || time_range.end.nil?
    find_or_initialize_events
  end

  private

  def find_or_initialize_events
    occurrences.map { |occurrence| find_or_initialize_event(occurrence) }
  end

  def occurrences
    schedule.occurrences_between(time_range.begin, time_range.end)
  end

  def find_or_initialize_event(occurrence)
    FindOrInitializeEvent.by(course, start_at: occurrence.to_time.change(usec: 0))
  end

  def set_schedule
    @schedule = IceCube::Schedule.new(schedule_start)
    add_weekly_schedules_to_schedule
    add_real_events_to_schedule
  end

  def add_real_events_to_schedule
    real_events.find_each do |event|
      schedule.add_recurrence_rule IceCube::SingleOccurrenceRule.new(event.start_at)
    end
  end

  def real_events
    course.events.where(start_at: time_range)
  end

  def add_weekly_schedules_to_schedule
    weekly_schedules.each do |weekly_schedule|
      schedule.add_recurrence_rule weekly_schedule.to_recurrence_rule
    end

    # This is a bug on Icecube. For more info, see:
    # https://github.com/seejohnrun/ice_cube/issues/298
    schedule.add_exception_time(schedule_start) if weekly_schedules.empty?
  end

  def schedule_start
    (course.start_date || course.created_at).beginning_of_day
  end
end
