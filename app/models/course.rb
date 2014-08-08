class Course < ActiveRecord::Base

  include HasUuid

  WEEKDAYS = (0..6).to_a

  belongs_to :teacher
  belongs_to :organization
  has_many :events
  has_many :weekly_schedules
  has_and_belongs_to_many :students

  validates :teacher, :name, :start_date, :end_date, :class_name, presence: true

  def channel
    "course_#{uuid}"
  end

  def order
    teacher.courses.order('created_at asc').index(self) + 1
  end

  def as_json(options = {})
    super(options.merge(methods: [:order]))
  end
end
