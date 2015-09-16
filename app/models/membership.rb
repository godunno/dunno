class Membership < ActiveRecord::Base
  belongs_to :profile
  belongs_to :course

  scope :as_teacher, -> { where(role: 'teacher') }

  default_scope -> { order(:id) }

  validates :profile, :role, presence: true
end
