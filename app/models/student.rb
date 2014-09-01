class Student < ActiveRecord::Base
  has_one :user, as: :profile
  has_and_belongs_to_many :courses
  has_many :events, through: :courses

  delegate :email, :authentication_token, :name, :phone_number, to: :user
end
