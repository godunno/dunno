class Event < ActiveRecord::Base

  PUSHER_EVENTS = {
    student_message: "student_message",
    up_down_vote_message: "up_down_vote_message",
    receive_poll: "receive_poll",
    receive_thermometer: "receive_thermometer"
  }

  STATUSES = %w(draft available opened closed)

  belongs_to :organization
  belongs_to :teacher
  has_one :timeline
  has_many :topics
  has_many :thermometers, inverse_of: :event

  validates :title, :start_at, :teacher, presence: true

  after_create :set_uuid
  after_create :set_timeline
  after_initialize :set_start_at

  accepts_nested_attributes_for :topics, :thermometers, allow_destroy: true

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

  def receive_thermometer_event
    PUSHER_EVENTS[:receive_thermometer]
  end

  STATUSES.each do |status|
    define_method "#{status}?" do
      self.status == status
    end
  end

  private
    def set_uuid
      UuidGenerator.new(self).generate!
    end

    def set_timeline
      self.timeline = Timeline.create!(start_at: start_at)
    end

    def set_start_at
      self[:start_at] ||= DateTime.now
    end
end
