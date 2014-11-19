class Media < ActiveRecord::Base
  include HasUuid

  CATEGORIES = %w(image video audio)

  acts_as_ordered_taggable

  belongs_to :mediable, polymorphic: true
  belongs_to :teacher

  delegate :event, to: :mediable

  mount_uploader :file, FileUploader

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
