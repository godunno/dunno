class WeeklySchedule < ActiveRecord::Base
  include HasUuid

  belongs_to :course

  validates :course, :weekday, :start_time, :end_time, presence: true
  validates :start_time, time_format: true
  validates :end_time, time_format: true
  validate :check_overlapping

  default_scope { order(:weekday) }

  delegate :overlaps?, to: :range

  def to_recurrence_rule
    time_of_day = Tod::TimeOfDay.parse start_time
    IceCube::Rule.weekly
      .day(weekday)
      .hour_of_day(time_of_day.hour)
      .minute_of_hour(time_of_day.minute)
      .second_of_minute(0)
      .until(course.try(:end_date))
  end

  def range
    Tod::Shift.new(Tod::TimeOfDay.parse(start_time), Tod::TimeOfDay.parse(end_time), true)
  end

  private

  def check_overlapping
    return unless course.present?
    course.weekly_schedules.each do |weekly_schedule|
      next if weekly_schedule == self
      next if weekly_schedule.weekday != weekday
      errors.add(:start_time, :overlapping) if weekly_schedule.overlaps?(range)
    end
  end
end
