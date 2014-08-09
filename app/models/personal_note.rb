class PersonalNote < ActiveRecord::Base
  include HasUuid
  belongs_to :event
end
