class WeeklySchedule < ActiveRecord::Base
  include HasUuid

  belongs_to :course

  validates :weekday, :start_time, :end_time, presence: true
  validates :start_time, time_format: true
  validates :end_time, time_format: true

  default_scope { order(:weekday) }

  def to_recurrence_rule
    time_of_day = TimeOfDay.parse start_time
    IceCube::Rule.weekly
      .day(weekday)
      .hour_of_day(time_of_day.hour)
      .minute_of_hour(time_of_day.minute)
      .second_of_minute(0)
      .until(course.try(:end_date))
  end
end
