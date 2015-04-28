class PersonalNote < ActiveRecord::Base
  belongs_to :event
  belongs_to :media
end
