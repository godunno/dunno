class Event < ActiveRecord::Base
  include HasUuid

  enum status: %w(draft published canceled)

  belongs_to :course, touch: true
  has_one :timeline
  has_many :thermometers, inverse_of: :event
  has_many :polls
  has_many :personal_notes
  has_many :topics
  belongs_to :beacon
  has_many :artifacts, through: :timeline
  has_many :polls,        through: :artifacts, source: :heir, source_type: 'Poll'
  has_many :thermometers, through: :artifacts, source: :heir, source_type: 'Thermometer'

  delegate :teacher, to: :course

  validates :course, presence: true
  validates :start_at, :end_at, presence: true

  accepts_nested_attributes_for :topics, :thermometers, :polls, :personal_notes, allow_destroy: true

  default_scope { order(:start_at) }

  def channel
    "event_#{uuid}"
  end

  def neighbors
    course.events.order('start_at asc')
  end

  def order
    @order ||= neighbors.index(self) + 1
  end

  def previous
    neighbors[order - 1 - 1] if order > 1
  end

  def next
    neighbors[order - 1 + 1] if order < neighbors.length
  end

  def close!
    return false if opened_at.nil?
    update(closed_at: Time.now)
  end

  def closed?
    closed_at.present?
  end

  def open!
    self.opened_at = Time.now
    save!
  end

  def opened?
    opened_at.present? && !closed?
  end

  def formatted_status
    return "empty" if empty?
    return "happened" if happened?
    status
  end

  %w(polls thermometers).each do |attr|
    define_method "#{attr}=" do |artifacts|
      artifacts.each do |artifact|
        timeline.artifacts << artifact.predecessor
        artifact.timeline = timeline
      end
    end
  end

  private

    def empty?
      draft? && topics.empty? && personal_notes.empty?
    end

    def happened?
      published? && end_at < Time.now
    end
end
