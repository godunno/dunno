class FindWeeklySchedule
  attr_reader :start_at, :weekly_schedules

  def initialize(start_at, weekly_schedules)
    @start_at = start_at
    @weekly_schedules = weekly_schedules
  end

  def end_at
    start_at.change(hour: end_time.hour, min: end_time.minute)
  end

  def classroom
    weekly_schedule.classroom
  end

  def weekly_schedule?
    weekly_schedule.present?
  end

  private

  def end_time
    @end_time ||= TimeOfDay.parse(weekly_schedule.end_time)
  end

  def weekly_schedule
    @weekly_schedule ||= weekly_schedules.find_by(start_time: start_at.strftime("%H:%M"), weekday: start_at.wday)
  end
end
