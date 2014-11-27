class Media < ActiveRecord::Base
  include HasUuid
  include Elasticsearch::Model
  index_name [Rails.env, model_name.collection].join('_')

  after_save    { Indexer.perform_async(:index,  id) }
  after_destroy { Indexer.perform_async(:delete, id) }

  CATEGORIES = %w(image video audio)

  acts_as_ordered_taggable

  belongs_to :mediable, polymorphic: true
  belongs_to :teacher

  delegate :event, to: :mediable

  mount_uploader :file, FileUploader

  # ElasticSearch representation
  def as_indexed_json(*)
    {
      title: title,
      tags: tag_list,
      teacher_id: teacher.id,
      created_at: created_at
    }
  end

  def release!
    self.status = "released"
    self.released_at = Time.now
    save!
  end

  def url
    super || file.url
  end

  def type
    return "file" if file.present?
    return "url" if url.present?
  end

  def self.search(options = {})
    query_string = options[:q].present? ? options[:q] : '*'
    query = {
      query: {
        filtered: {
          query: {
            # Fulltext search
            query_string: {
              query: query_string
            }
          }
        }
      },
      sort: [:created_at]
    }
    if options[:filter].present?
      query[:query][:filtered][:filter] = { term: options[:filter] }
    end
    result = __elasticsearch__.search(query)
    result = result.page(options[:page]) if options[:page].present?
    result
  end

  def self.per_page
    10
  end
end
