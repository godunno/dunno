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
  scope :last_published, -> { published.last }

  def self.import
    Course.find_each do |course|
      CourseEventsIndexerWorker.new.perform(course.id)
    end
  end

  # ElasticSearch representation
  def as_indexed_json(*)
    {
      course_id: course_id,
      start_at: start_at
    }
  end

  def formatted_status(profile)
    return "empty" if empty? || draft? && profile.role_in(course) == 'student'
    return "happened" if happened?
    status
  end

  def index_id
    "#{course.id}/#{start_at.iso8601}"
  end

  private

    def empty?
      draft? && topics.empty?
    end

    def happened?
      published? && end_at < Time.now
    end
end
