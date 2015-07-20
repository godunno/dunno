class EventService
  attr_reader :course, :schedule, :time_range

  def initialize(course, time = Time.current)
    @course = course
    @time_range = time.beginning_of_month..time.end_of_month
    set_schedule
  end

  def events
    find_or_initialize_events
  end

  private

  def find_or_initialize_events
    occurrences_with_index
      .drop_while { |o, i| o < time_range.begin }
      .take_while { |o, i| time_range.cover? o }
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
    course.events.find_or_initialize_by(start_at: occurrence.to_time.change(usec: 0)) do |event|
      event.order = index + 1
    end
  end

  def set_schedule
    @schedule = IceCube::Schedule.new(course.start_date || course.created_at)
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
    course.weekly_schedules.each do |weekly_schedule|
      schedule.add_recurrence_rule rule_for_weekly_schedule(weekly_schedule)
    end
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
end
