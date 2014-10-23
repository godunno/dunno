class Media < ActiveRecord::Base
  include HasUuid

  CATEGORIES = %w(image video audio)

  belongs_to :topic

  validates :title, presence: true
  validates :category, presence: true, inclusion: { in: CATEGORIES }
  validates :url, format: URI.regexp(:http), allow_blank: true
  validate :mutually_exclusive_url_and_file

  delegate :event, to: :topic

  mount_uploader :file, FileUploader

  def release!
    self.status = "released"
    self.released_at = Time.now
    save!
  end

  private

    def mutually_exclusive_url_and_file
      if url.present? && file.file.try(:exists?)
        errors.add(:url)
      end
    end
end
