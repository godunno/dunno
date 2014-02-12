class EventSerializer < ActiveModel::Serializer
  attributes :organization_id, :id, :title, :uuid, :channel, :student_message_event, :up_down_vote_message_event, :receive_poll_event, :receive_rating_event

  has_one :timeline
end
