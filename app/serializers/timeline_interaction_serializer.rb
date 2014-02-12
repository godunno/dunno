class TimelineInteractionSerializer < ActiveModel::Serializer
  attributes :interaction_type

  has_one :interaction
end
