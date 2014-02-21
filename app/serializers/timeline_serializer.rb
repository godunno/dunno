class TimelineSerializer < ActiveModel::Serializer
  attributes :id, :start_at, :created_at, :updated_at, :messages

  def messages
    object.timeline_interactions.messages.map { |ti| ti.interaction }
  end
end
