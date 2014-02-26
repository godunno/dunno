class EventSerializer < ActiveModel::Serializer
  attributes :organization_id, :teacher, :id, :title, :uuid, :duration, :start_at, :channel, :student_message_event,
             :up_down_vote_message_event, :receive_poll_event, :receive_thermometer_event

  has_one :timeline
  has_many :topics
end
