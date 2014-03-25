class Event < ActiveRecord::Base

  PUSHER_EVENTS = {
    student_message: "student_message",
    up_down_vote_message: "up_down_vote_message",
    receive_rating: "receive_rating",
    close: "close",
    release_poll: "release_poll"
  }

  STATUSES = %w(available opened closed)

  belongs_to :course
  has_one :timeline
  has_many :topics
  has_many :thermometers, inverse_of: :event
  has_many :polls
  has_many :personal_notes

  validates :title, :start_at, :duration, presence: true
  validates :closed_at, presence: true, if: :closed?

  after_create :set_uuid
  after_create :set_timeline
  after_initialize :set_start_at

  accepts_nested_attributes_for :topics, :thermometers, :polls, :personal_notes, allow_destroy: true

  default_scope { order(:start_at) }

  def channel
    "event_#{uuid}"
  end

  def student_message_event
    PUSHER_EVENTS[:student_message]
  end

  def up_down_vote_message_event
    PUSHER_EVENTS[:up_down_vote_message]
  end

  def receive_rating_event
    PUSHER_EVENTS[:receive_rating]
  end

  def close_event
    PUSHER_EVENTS[:close]
  end

  def release_poll_event
    PUSHER_EVENTS[:release_poll]
  end

  STATUSES.each do |status|
    define_method "#{status}?" do
      self.status == status
    end
  end

  def close!
    self.status = "closed"
    self.closed_at = Time.now
    save!
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
