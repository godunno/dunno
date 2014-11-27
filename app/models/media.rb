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
      tags: tag_list
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

end
