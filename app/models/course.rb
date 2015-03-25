class Course < ActiveRecord::Base
  include HasUuid

  WEEKDAYS = (0..6).to_a

  belongs_to :teacher
  belongs_to :organization
  has_many :events
  has_many :weekly_schedules
  has_many :notifications
  has_and_belongs_to_many :students

  validates :teacher, :name, :start_date, :end_date, :class_name, presence: true

  before_create :set_access_code

  default_scope -> { order(:created_at) }

  def self.find_by_identifier!(identifier)
    where('access_code = ? OR uuid = ?', identifier, identifier).first!
  end

  def add_student(student)
    students << student
    touch
  end

  def channel
    "course_#{uuid}"
  end

  def order
    teacher.courses.order('created_at asc').index(self) + 1
  end

  def as_json(options = {})
    super(options.merge(methods: [:order]))
  end

  def abbreviation
    name
  end

  private

    def set_access_code
      loop do
        self.access_code = SecureRandom.hex(2)
        break unless Course.exists?(access_code: access_code)
      end
    end
end
