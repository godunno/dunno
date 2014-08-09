class WeeklySchedule < ActiveRecord::Base
  belongs_to :course

  validates :weekday, :start_time, :end_time, presence: true
  validates :start_time, :end_time, time_format: true
end
