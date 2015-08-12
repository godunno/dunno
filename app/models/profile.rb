class Profile < ActiveRecord::Base
  has_one :user
  has_many :memberships, dependent: :destroy
  has_many :courses, through: :memberships
  has_many :events, through: :courses
  has_many :medias, dependent: :destroy

  delegate :uuid, :email, :authentication_token, :name, :phone_number,
    :completed_tutorial, to: :user

  def role_in(course)
    memberships.find_by!(course: course).role
  end

  def has_course?(course)
    memberships.find_by(course: course).present?
  end

  def students_count
    courses_as_teacher.includes(:students).flat_map(&:students).uniq.size
  end

  def notifications_count
    courses_as_teacher.includes(:notifications).flat_map(&:notifications).size
  end

  def create_course!(attributes)
    Course.create!(attributes.merge(teacher: self))
  end

  private

  def courses_as_teacher
    courses.merge(Membership.as_teacher)
  end
end
