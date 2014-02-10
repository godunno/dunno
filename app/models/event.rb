class Event < ActiveRecord::Base

  PUSHER_EVENTS = {
    student_message: "student_message",
    up_down_vote_message: "up_down_vote_message",
    receive_poll: "receive_poll",
    receive_rating: "receive_rating"
  }

  STATUSES = %w(draft available opened closed)

  belongs_to :organization
  has_one :timeline

  validates :title, :start_at, presence: true

  after_create :set_uuid
  after_create :set_timeline

  def channel
    "event_#{uuid}"
  end

  def student_message_event
    PUSHER_EVENTS[:student_message]
  end

  def up_down_vote_message_event
    PUSHER_EVENTS[:up_down_vote_message]
  end

  def receive_poll_event
    PUSHER_EVENTS[:receive_poll]
  end

  def receive_rating_event
    PUSHER_EVENTS[:receive_rating]
  end

  def to_json(options = {})
    options = {
      include: { timeline: { methods: :interactions }},
      methods: [:channel] + PUSHER_EVENTS.map { |key, value| "#{key}_event" }
    }.merge options
    super(options)
  end

  private
    def set_uuid
      UuidGenerator.new(self).generate!
    end

    def set_timeline
      self.timeline = Timeline.create!(start_at: start_at)
    end
end
