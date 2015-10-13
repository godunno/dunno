class WeeklyRule
  delegate :course, to: :weekly_schedule

  def initialize(weekly_schedule)
    self.weekly_schedule = weekly_schedule
  end

  def rule_for_event_listing
    base_rule.until(course.end_date)
  end

  def rule_for_weekly_schedule_transfer
    base_rule.until(end_time)
  end

  private

  attr_accessor :weekly_schedule

  def base_rule
    IceCube::Rule.weekly
      .day(weekly_schedule.weekday)
      .hour_of_day(time_of_day.hour)
      .minute_of_hour(time_of_day.minute)
      .second_of_minute(0)
  end

  def time_of_day
    Tod::TimeOfDay.parse weekly_schedule.start_time
  end

  def end_time
    course.end_date ||
      last_event && last_event.start_at + 1.week ||
      Time.current
  end

  def last_event
    course.events.reload.last
  end
end
