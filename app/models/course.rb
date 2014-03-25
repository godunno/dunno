class Course < ActiveRecord::Base

  WEEKDAYS = %w(sun mon tue wed thu fri sat)

  belongs_to :teacher
  belongs_to :organization
  has_many :events
  has_and_belongs_to_many :students

  validates :teacher, :weekdays, :start_date, :end_date, :start_time, :end_time, presence: true

  after_create :set_uuid
  before_save :strip_weekdays

  private
    def set_uuid
      UuidGenerator.new(self).generate!
    end

    def strip_weekdays
      weekdays.reject!(&:blank?)
    end
end
