class Media < ActiveRecord::Base
  include HasUuid
  include Elasticsearch::Model
  index_name [Rails.env, model_name.collection].join('_')

  after_commit on: [:create, :update] { Indexer.perform_async(:index, id) }
  after_commit on: [:destroy] { Indexer.perform_async(:delete, id) }

  CATEGORIES = %w(image video audio)

  acts_as_ordered_taggable

  belongs_to :mediable, polymorphic: true
  belongs_to :teacher

  delegate :event, to: :mediable

  mount_uploader :file, FileUploader

  settings index: { number_of_shards: 1 }, analysis: {
    filter: {
      ngram_filter: {
        type: "edge_ngram",
        min_gram: 3,
        max_gram: 20
      }
    },
    analyzer: {
      ngram_analyzer: {
        tokenizer: "standard",
        filter: %w(lowercase ngram_filter),
        type: "custom"
      }
    }
  } do
    mapping do
      indexes :title, type: 'string', analyzer: 'ngram_analyzer'
      indexes :tags, type: 'string', analyzer: 'ngram_analyzer'
      indexes :teacher_id, type: :integer
      indexes :created_at, type: :date
    end
  end

  # ElasticSearch representation
  def as_indexed_json(*)
    {
      title: title,
      tags: tag_list.to_a,
      teacher_id: teacher_id,
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
              query: query_string,
              fields: %w(title tags)
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
    result = result.page(options[:page] || 1)
    result
  end

  def self.per_page
    10
  end
end
