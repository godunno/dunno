class Topic < ActiveRecord::Base
  belongs_to :event
  has_many :ratings, as: :rateable

end
