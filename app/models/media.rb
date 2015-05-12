class Media < ActiveRecord::Base
  include HasUuid
  include HasFile
  include Elasticsearch::Model
  index_name [Rails.env, model_name.collection].join('_')

  after_commit on: [:create, :update] { Indexer.perform_async(:index, id) }
  after_commit on: [:destroy] { Indexer.perform_async(:delete, id) }

  CATEGORIES = %w(image video audio)

  acts_as_ordered_taggable

  belongs_to :mediable, polymorphic: true
  belongs_to :teacher
  has_many :topics
  has_many :events, through: :topics

  validates :title, presence: true

  mount_uploader :file_carrierwave, FileUploader

  delegate :event, to: :mediable

  settings index: { number_of_shards: 1 }, analysis: {
    tokenizer: {
      ngram: {
        type: :ngram,
        min_gram: 3,
        max_gram: 20
      }
    },
    filter: {
      snowball: {
        type: :snowball,
        language: :portuguese
      },
      stopwords: {
        type: :stop,
        stopwords: '[_portuguese_]',
        ignore_case: true
      },
      stemmer: {
        type: :stemmer,
        language: :portuguese
      }
    },
    analyzer: {
      custom_analyzer: {
        tokenizer: :ngram,
        filter: %w(stopwords asciifolding lowercase snowball stemmer),
        type: :custom
      }
    }
  } do
    mapping do
      indexes :title, type: :string, analyzer: :custom_analyzer
      indexes :tags, type: :string, analyzer: :custom_analyzer
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

  def url
    super || file.try(:url)
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
              fields: %w(title tags),
              analyzer: :custom_analyzer
            }
          }
        }
      },
      sort: [created_at: :desc]
    }
    if options[:filter].present?
      query[:query][:filtered][:filter] = { term: options[:filter] }
    end
    result = __elasticsearch__.search(query)
    result = result.per_page(options[:per_page] || 10).page(options[:page] || 1)
    result
  end
end
