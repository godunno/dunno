class Course < ActiveRecord::Base
  belongs_to :teacher
  belongs_to :organization
  has_many :events
  has_and_belongs_to_many :students

  validates :teacher, presence: true
end
