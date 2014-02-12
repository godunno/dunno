class TimelineSerializer < ActiveModel::Serializer
  attributes :id, :start_at, :created_at, :updated_at

  has_many :timeline_interactions
end
