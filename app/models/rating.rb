class Rating < ActiveRecord::Base
  belongs_to :rateable, polymorphic: true

end
