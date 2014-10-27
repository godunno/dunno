class Media < ActiveRecord::Base
  include HasUuid

  CATEGORIES = %w(image video audio)

  belongs_to :topic

  delegate :event, to: :topic

  mount_uploader :file, FileUploader

  def release!
    self.status = "released"
    self.released_at = Time.now
    save!
  end
end
