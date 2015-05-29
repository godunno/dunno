class Profile < ActiveRecord::Base
  has_one :user
  has_many :memberships
  has_many :courses, through: :memberships
  has_many :events, through: :courses
  has_many :medias

  delegate :uuid, :email, :authentication_token, :name, :phone_number, :completed_tutorial, to: :user
end
