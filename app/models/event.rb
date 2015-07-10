class Event < ActiveRecord::Base
  include HasUuid
  include Elasticsearch::Model
  index_name [Rails.env, model_name.collection].join('_')

  settings index: { number_of_shards: 1 } do
    mapping do
      indexes :course_id, type: :integer
      indexes :start_at, type: :date
    end
  end

  enum status: %w(draft published canceled)

  belongs_to :course, touch: true
  has_many :topics

  delegate :teacher, to: :course

  validates :course, presence: true
  validates :start_at, :end_at, presence: true

  default_scope { order(:start_at).includes(:topics) }

  scope :not_canceled, -> { where('status <> ?', Event.statuses[:canceled]) }

  def self.__elasticsearch_query__(course, options)
    query = {
      sort: [start_at: :desc],
      query: {
        bool: {
          must: [
            filtered: {
              filter: {
                term: {
                  course_id: course.id
                }
              }
            }
          ]
        }
      }
    }

    newer_event = course.events.unscoped.published.order(start_at: :desc).limit(1).first
    start_at_range = {
      range: {
        start_at: {
          lte: newer_event.try(:start_at)
        }
      }
    }

    if options[:until].present? && options[:until] <= newer_event.start_at
      start_at_range[:range][:start_at][:gte] = options[:until]
      query[:size] = course.events.count
    else
      per_page = (options[:per_page] || 10).to_i
      offset = options[:offset].to_i
      page = [options[:page].to_i - 1, 0].max

      query[:size] = per_page
      query[:from] = offset + (page * per_page)
    end

    query[:query][:bool][:must] << start_at_range

    query
  end

  def self.search_by_course(course, options)
    __elasticsearch__.search(__elasticsearch_query__(course, options))
  end

  private_class_method :search

  # ElasticSearch representation
  def as_indexed_json(*)
    {
      course_id: course_id,
      start_at: start_at
    }
  end

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

  def formatted_status(profile)
    return "empty" if empty? || draft? && profile.role_in(course) == 'student'
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
