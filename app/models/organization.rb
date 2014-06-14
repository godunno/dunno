class Organization < ActiveRecord::Base

  include HasUuid

  has_many :courses
  has_and_belongs_to_many :teachers

  validates :name, presence: true
end
