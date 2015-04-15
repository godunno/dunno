class Event < ActiveRecord::Base
  include HasUuid

  enum status: %w(draft published canceled)

  belongs_to :course, touch: true
  has_many :topics

  delegate :teacher, to: :course

  validates :course, presence: true
  validates :start_at, :end_at, presence: true

  default_scope { order(:start_at).includes(:topics) }

  scope :not_canceled, -> { where('status <> ?', Event.statuses[:canceled]) }

  def next_not_canceled
    neighbors.not_canceled.where('start_at > ?', start_at).first
  end

  def neighbors
    course.events
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

  def formatted_status
    return "empty" if empty?
    return "happened" if happened?
    status
  end

  private

    def empty?
      draft? && topics.empty?
    end

    def happened?
      published? && end_at < Time.now
    end
end
