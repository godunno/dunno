class Membership < ActiveRecord::Base
  belongs_to :profile
  belongs_to :course

  scope :as_teacher, -> { where(role: 'teacher') }

  default_scope -> { order(:id) }

  validates :profile, :role, presence: true
  validate :assert_did_not_change_teacher

  private

  def assert_did_not_change_teacher
    errors.add(:role, :is_teacher) if role_changed? && role_was == 'teacher'
  end
end
