class Topic < ActiveRecord::Base
  include HasUuid

  belongs_to :event

  has_many :ratings, as: :rateable

  validates :description, presence: true
end
