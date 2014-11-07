class PersonalNote < ActiveRecord::Base
  include HasUuid
  belongs_to :event
  has_one :media
end
