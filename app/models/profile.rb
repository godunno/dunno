class Profile < ActiveRecord::Base
  has_one :user
  has_many :memberships, dependent: :destroy
  has_many :courses,
           -> { includes(:memberships).where('memberships.role != ?', 'blocked') },
           through: :memberships
  has_many :courses_with_blocked, through: :memberships, source: :course
  has_many :events, through: :courses
  has_many :medias, dependent: :destroy
  has_many :system_notifications, dependent: :destroy
  has_many :tracking_events, dependent: :destroy

  delegate :uuid, :email, :authentication_token, :name, :avatar_url, to: :user

  after_create :set_last_digest_sent_at

  def role_in(course)
    has_course?(course) && membership_in(course).role
  end

  def has_course?(course)
    membership_in(course).present?
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

  def block_in!(course)
    membership_in!(course).update!(role: 'blocked')
  end

  def unblock_in!(course)
    membership_in!(course).update!(role: 'student')
  end

  def blocked_in?(course)
    membership = membership_in(course)
    membership && membership.role == 'blocked'
  end

  def promote_to_moderator_in!(course)
    membership_in!(course).update!(role: 'moderator')
  end

  def downgrade_from_moderator_in!(course)
    membership_in!(course).update!(role: 'student')
  end

  def moderator_in?(course)
    membership = membership_in(course)
    membership && membership.role == 'moderator'
  end

  private

  def courses_as_teacher
    courses.merge(Membership.as_teacher)
  end

  def membership_in(course)
    memberships.find_by(course: course)
  end

  def membership_in!(course)
    memberships.find_by!(course: course)
  end

  def set_last_digest_sent_at
    self.last_digest_sent_at = Time.current
  end
end
