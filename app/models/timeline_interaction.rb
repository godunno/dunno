class TimelineInteraction < ActiveRecord::Base
  belongs_to :timeline
  belongs_to :interaction, polymorphic: true

  scope :messages, -> { where(interaction_type: "TimelineUserMessage").order(:created_at) }
end
