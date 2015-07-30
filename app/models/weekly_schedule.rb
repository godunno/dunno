class WeeklySchedule < ActiveRecord::Base
  include HasUuid

  belongs_to :course

  validates :weekday, presence: true
  validates :start_time, time_format: true, if: -> { start_time.present? }
  validates :end_time, time_format: true, if: -> { end_time.present? }

  default_scope { order(:weekday) }

  scope :complete, -> { where.not(start_time: [nil, ''], end_time: [nil, '']) }

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
