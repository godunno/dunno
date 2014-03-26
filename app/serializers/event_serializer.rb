class EventSerializer < ActiveModel::Serializer
  attributes :id, :title, :uuid, :duration, :start_at, :channel, :student_message_event,
             :up_down_vote_message_event, :release_poll_event, :receive_rating_event, :status

  has_one :timeline
  has_one :course
  has_many :topics
end
