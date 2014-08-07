class Course < ActiveRecord::Base

  include HasUuid

  WEEKDAYS = (0..6).to_a

  belongs_to :teacher
  belongs_to :organization
  has_many :events
  has_and_belongs_to_many :students

  validates :teacher, :weekdays, :start_date, :end_date, :start_time, :end_time, presence: true

  before_save :prepare_weekdays

  def channel
    "course_#{uuid}"
  end

  def order
    teacher.courses.order('created_at asc').index(self) + 1
  end

  def as_json(options = {})
    super(options.merge(methods: [:order]))
  end

  private
    def prepare_weekdays
      weekdays.reject!(&:blank?)
      self.weekdays = weekdays.map(&:to_i)
    end
end
