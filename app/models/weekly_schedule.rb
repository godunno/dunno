class WeeklySchedule < ActiveRecord::Base
  include HasUuid

  belongs_to :course

  validates :course, :weekday, :start_time, :end_time, presence: true
  validates :start_time, time_format: true
  validates :end_time, time_format: true
  validate :check_overlapping
  validate :assert_start_time_comes_before_end_time

  default_scope { order(:weekday) }

  delegate :overlaps?, to: :range

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

  def assert_start_time_comes_before_end_time
    start_time_of_day = Tod::TimeOfDay.try_parse(start_time)
    end_time_of_day = Tod::TimeOfDay.try_parse(end_time)
    return unless start_time_of_day.present? && end_time_of_day.present?

    errors.add(:start_time, :after_end_time) if start_time_of_day > end_time_of_day
  end
end
