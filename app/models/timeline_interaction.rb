class TimelineInteraction < ActiveRecord::Base
  belongs_to :timeline
  belongs_to :interaction, polymorphic: true
end
