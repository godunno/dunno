class EventService
  attr_reader :course, :schedule, :time_range, :current_month
  delegate :weekly_schedules, to: :course

  def initialize(course, current_month)
    @current_month = (current_month || Time.current).beginning_of_month
    @course = course
    @time_range = @current_month..@current_month.end_of_month
    set_schedule
  end

  def events
    find_or_initialize_events
  end

  def previous_month
    current_month - 1.month
  end

  def next_month
    current_month + 1.month
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
    course.events.find_or_initialize_by(start_at: occurrence.to_time.change(usec: 0)).tap do |event|
      event.order = index + 1
      weekly_schedule = weekly_schedules.find_by(start_time: event.start_at.strftime("%H:%M"))
      next unless weekly_schedule.present?
      event.classroom ||= weekly_schedule.classroom
      end_time = TimeOfDay.parse(weekly_schedule.end_time)
      event.end_at ||= event.start_at.change(hour: end_time.hour, min: end_time.minute)
    end
  end

  def set_schedule
    @schedule = IceCube::Schedule.new(schedule_start, duration: 1000)
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
    return unless weekly_schedules.empty?
    schedule.add_exception_time(schedule_start)
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
    course.start_date || course.created_at
  end
end
