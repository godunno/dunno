class CourseScheduler
  attr_reader :course, :schedule, :time_range, :current_month
  delegate :weekly_schedules, to: :course

  def initialize(course, time_range = nil)
    @course = course
    @time_range = time_range
    if time_range.blank?
      @time_range = if course.start_date.present? && course.end_date.present?
                      course.start_date.beginning_of_day..course.end_date.end_of_day
                    else
                      now = Time.current
                      now.beginning_of_month..now.end_of_month
                    end
    end
    set_schedule
  end

  def events
    find_or_initialize_events
  end

  private

  def find_or_initialize_events
    occurrences_with_index
      .drop_while { |o, _| o < time_range.begin }
      .take_while { |o, _| time_range.cover? o }
      .map { |o, i| find_or_initialize_event(o, i) }
      .to_a
  end

  def occurrences_with_index
    schedule
      .all_occurrences_enumerator
      .lazy
      .each_with_index
  end

  def find_or_initialize_event(occurrence, index)
    FindOrInitializeEvent.new(course).by({ start_at: occurrence.to_time.change(usec: 0) }, index + 1)
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
      schedule.add_recurrence_rule rule_for_weekly_schedule(weekly_schedule)
    end

    # TODO: Find a solution to this bug
    # https://github.com/seejohnrun/ice_cube/issues/298
    schedule.add_exception_time(schedule_start) if weekly_schedules.empty?
  end

  def rule_for_weekly_schedule(weekly_schedule)
    time_of_day = TimeOfDay.parse weekly_schedule.start_time
    IceCube::Rule.weekly
      .day(weekly_schedule.weekday)
      .hour_of_day(time_of_day.hour)
      .minute_of_hour(time_of_day.minute)
      .second_of_minute(0)
      .until(course.end_date)
  end

  def schedule_start
    (course.start_date || course.created_at).beginning_of_day
  end
end
