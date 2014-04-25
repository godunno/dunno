class Course < ActiveRecord::Base

  WEEKDAYS = (0..6).to_a

  belongs_to :teacher
  belongs_to :organization
  has_many :events
  has_and_belongs_to_many :students

  validates :teacher, :weekdays, :start_date, :end_date, :start_time, :end_time, presence: true

  after_create :set_uuid
  before_save :prepare_weekdays

  def channel
    "course_#{uuid}"
  end

  private
    def set_uuid
      UuidGenerator.new(self).generate!
    end

    def prepare_weekdays
      weekdays.reject!(&:blank?)
      self.weekdays = weekdays.map(&:to_i)
    end
end
