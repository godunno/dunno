class Rating < ActiveRecord::Base
  belongs_to :rateable, polymorphic: true
  belongs_to :student

end
