class Membership < ActiveRecord::Base
  belongs_to :profile
  belongs_to :course

  scope :as_teacher, -> { where(role: 'teacher') }

  default_scope -> { order(:id) }

  # TODO: validate presence of course (need to use inverse_of on the association)
  validates :profile, :role, presence: true
end
