class Event < ActiveRecord::Base
  include HasUuid
  include Elasticsearch::Model
  include IndexedModel

  attr_writer :index_id

  enum status: %w(draft published canceled new_topic)

  belongs_to :course, touch: true
  has_many :topics
  has_many :comments, dependent: :destroy
  has_many :system_notifications, dependent: :destroy, as: :notifiable

  delegate :teacher, to: :course

  validates :course, presence: true
  validates :start_at, :end_at, presence: true

  default_scope { order(:start_at).includes(:topics) }

  scope :not_canceled, -> { where('status <> ?', Event.statuses[:canceled]) }

  after_save :touch_topics

  def self.last_published
    published.last
  end

  def self.by_start_at(start_at)
    find_by(start_at: (start_at - 1)..(start_at + 1))
  end

  settings index: { number_of_shards: 1 } do
    mapping do
      indexes :course_id, type: :integer
      indexes :start_at, type: :date
    end
  end

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

  def index_id
    @index_id ||= "#{course.id}_#{start_at.iso8601}"
  end

  def was_canceled?
    _old_status, new_status = previous_changes["status"]
    new_status == 'canceled'
  end

  private

  def touch_topics
    topics.update_all(updated_at: Time.current)
  end
end
