class WeeklySchedule < ActiveRecord::Base
  include HasUuid

  belongs_to :course

  validates :weekday, presence: true
  validates :start_time, time_format: true, if: -> { start_time.present? }
  validates :end_time, time_format: true, if: -> { end_time.present? }

  default_scope { order(:weekday) }

  scope :complete, -> { where.not(start_time: [nil, ''], end_time: [nil, '']) }
end
