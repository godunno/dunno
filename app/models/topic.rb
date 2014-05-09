class Topic < ActiveRecord::Base

  acts_as_heir_of :artifact

  has_many :ratings, as: :rateable

  validates :description, presence: true

end
