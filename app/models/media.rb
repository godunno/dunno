class Media < ActiveRecord::Base
  include HasUuid

  CATEGORIES = %w(image video audio)

  belongs_to :topic

  validates :url, format: URI.regexp(:http), allow_blank: true
  validate :mutually_exclusive_url_or_file

  delegate :event, to: :topic

  mount_uploader :file, FileUploader

  def release!
    self.status = "released"
    self.released_at = Time.now
    save!
  end

  private

    def mutually_exclusive_url_or_file
      %w(url file).each do |attribute|
        if url.nil? && !file.file.try(:exists?)
          errors.add(attribute, :blank)
        elsif url.present? && file.file.try(:exists?)
          errors.add(attribute, :invalid)
        end
      end
    end
end
