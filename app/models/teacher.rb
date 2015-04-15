class Teacher < ActiveRecord::Base
  has_one :user, as: :profile
  has_many :courses
  has_many :events, through: :courses
  has_many :medias

  delegate :email, :authentication_token, :name, :phone_number, :completed_tutorial, to: :user
end
