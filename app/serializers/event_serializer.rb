class EventSerializer < ActiveModel::Serializer
  attributes :teacher, :id, :title, :uuid, :duration, :start_at, :channel, :student_message_event,
             :up_down_vote_message_event, :release_poll_event, :receive_rating_event

  has_one :timeline
  has_many :topics
end
