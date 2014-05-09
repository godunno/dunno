class Media < ActiveRecord::Base

  acts_as_heir_of :artifact

  CATEGORIES = %w(image video audio)

  validates :title, presence: true
  validates :category, presence: true, inclusion: { in: CATEGORIES }
  validates :url, format: URI::regexp(:http), allow_blank: true
  validate :mutually_exclusive_url_and_file

  after_create :set_uuid

  mount_uploader :file, FileUploader

  def release!
    self.status = "released"
    self.released_at = Time.now
    save!
  end

  private
    def set_uuid
      UuidGenerator.new(self).generate!
    end

    def mutually_exclusive_url_and_file
      if self.url && self.file.file.try(:exists?)
        errors.add(:url)
      end
    end
end
