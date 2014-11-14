class Media < ActiveRecord::Base
  include HasUuid

  CATEGORIES = %w(image video audio)

  acts_as_taggable

  belongs_to :mediable, polymorphic: true
  belongs_to :teacher

  delegate :event, to: :mediable

  mount_uploader :file, FileUploader

  def release!
    self.status = "released"
    self.released_at = Time.now
    save!
  end

  def type
    return "url" if url.present?
    return "file" if file.present?
  end

  # TODO: set preview after Carrierwave has stored the file
  def preview
    if url.present?
      super
    else
      {
        "url" => file.url,
        "title" => file_identifier
      }
    end
  end
end
