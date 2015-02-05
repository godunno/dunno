class Topic < ActiveRecord::Base
  include HasUuid

  belongs_to :event

  has_many :ratings, as: :rateable
  has_one :media, as: :mediable

  validate :ensure_description_or_media_present

  private

  def ensure_description_or_media_present
    return if description.present? || media.present?
    errors.add(:description, :blank_content)
    errors.add(:media, :blank_content)
  end
end
