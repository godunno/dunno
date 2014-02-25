class Thermometer < ActiveRecord::Base
  belongs_to :event
  has_many :ratings, as: :rateable

  validates :event, presence: true
  validates :content, presence: true
end
