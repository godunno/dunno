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
end
