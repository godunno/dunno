class Media < ActiveRecord::Base

  CATEGORIES = [
    IMAGE = 0,
    VIDEO = 1,
    AUDIO = 2
  ]

  belongs_to :event

  validates :title, presence: true
  validates :category, presence: true, inclusion: { in: CATEGORIES }
  validates :url, format: URI::regexp(:http)

  after_create :set_uuid

  mount_uploader :file, FileUploader

  private
    def set_uuid
      UuidGenerator.new(self).generate!
    end
end
