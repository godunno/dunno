class PersonalNote < ActiveRecord::Base
  include HasUuid

  belongs_to :event, touch: true
  belongs_to :media

  validate :ensure_description_or_media_present

  private

  def ensure_description_or_media_present
    return if description.present? || media.present?
    errors.add(:description, :blank_content)
    errors.add(:media, :blank_content)
  end
end
