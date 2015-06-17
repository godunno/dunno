class Course < ActiveRecord::Base
  include HasUuid

  WEEKDAYS = (0..6).to_a

  has_one :teacher_membership, -> { where(role: 'teacher') }, class_name: 'Membership'
  has_many :student_memberships, -> { where(role: 'student') }, class_name: 'Membership'
  has_one :teacher, through: :teacher_membership, class_name: 'Profile', source: :profile
  has_many :students, through: :student_memberships, class_name: 'Profile', source: :profile
  has_many :events
  has_many :weekly_schedules
  has_many :notifications

  validates :name, :start_date, :end_date, :class_name, :teacher, presence: true
  validates :abbreviation, length: { maximum: 10 }

  before_create :set_access_code

  default_scope -> { order(:created_at) }

  def self.find_by_identifier!(identifier)
    where('access_code = ? OR uuid = ?', identifier, identifier).first!
  end

  def add_student(student)
    students << student
    touch
  end

  def order
    teacher.courses.order('created_at asc').index(self) + 1
  end

  def as_json(options = {})
    super(options.merge(methods: [:order]))
  end

  def abbreviation
    super || (Abbreviate.abbreviate(name) if name.present?)
  end

  private

  def set_access_code
    loop do
      self.access_code = SecureRandom.hex(2)
      break unless Course.exists?(access_code: access_code)
    end
  end
end
