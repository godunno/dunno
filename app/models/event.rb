class Event < ActiveRecord::Base

  include HasUuid

  STATUSES = %w(available opened closed)

  belongs_to :course
  has_one :timeline
  has_many :thermometers, inverse_of: :event
  has_many :polls
  has_many :personal_notes
  belongs_to :beacon
  has_many :artifacts, through: :timeline
  has_many :topics,       through: :artifacts, source: :heir, source_type: 'Topic'
  has_many :polls,        through: :artifacts, source: :heir, source_type: 'Poll'
  has_many :thermometers, through: :artifacts, source: :heir, source_type: 'Thermometer'
  has_many :medias,       through: :artifacts, source: :heir, source_type: 'Media'

  delegate :teacher, to: :course

  validates :course, presence: true
  validates :start_at, :end_at, presence: true
  validates :closed_at, presence: true, if: :closed?

  accepts_nested_attributes_for :topics, :thermometers, :polls, :personal_notes, :medias, allow_destroy: true

  default_scope { order(:start_at) }

  def channel
    "event_#{uuid}"
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

  def open!
    self.status = "opened"
    self.opened_at = Time.now
    save!
  end

  %w(topics polls medias thermometers).each do |attr|
    define_method "#{attr}=" do |artifacts|
      artifacts.each do |artifact|
        timeline.artifacts << artifact.predecessor
        artifact.timeline = timeline
      end
    end
  end
end
