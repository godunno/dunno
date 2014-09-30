require 'recurrence'

class CreateSchedule
  def initialize(start_date, end_date, weekly_schedules)
    @start_date = start_date
    @end_date = end_date
    @weekly_schedules = weekly_schedules
  end

  def schedule_for(weekly_schedule)
    schedule = Recurrence.new(
      every:  :week,
      on:     weekly_schedule.weekday,
      starts: @start_date,
      until:  @end_date
    )

    start_time = TimeOfDay.parse(weekly_schedule.start_time)
    end_time = TimeOfDay.parse(weekly_schedule.end_time)

    schedule.map do |date|
      range_start = date.in_time_zone.change(
        hour: start_time.hour,
        min:  start_time.minute
      )

      range_end = date.in_time_zone.change(
        hour: end_time.hour,
        min:  end_time.minute
      )

      range_start..range_end
    end
  end

  def schedule
    schedules = @weekly_schedules.map { |w| schedule_for(w) }.flatten
    schedules.sort_by { |schedule| schedule.begin }
  end
end
