class Topic < ActiveRecord::Base
  include HasUuid

  belongs_to :event, touch: true
  belongs_to :media, touch: true
  has_many :ratings, as: :rateable
  has_many :system_notifications, dependent: :destroy, as: :notifiable

  validate :ensure_description_or_media_present

  scope :without_personal, -> { where(personal: false) }

  default_scope -> { order(order: :desc) }

  private

  def ensure_description_or_media_present
    return if description.present? || media.present?
    errors.add(:description, :blank_content)
    errors.add(:media, :blank_content)
  end
end
