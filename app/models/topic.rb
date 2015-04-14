class Topic < ActiveRecord::Base
  include HasUuid

  belongs_to :event, touch: true
  has_many :ratings, as: :rateable
  belongs_to :media

  validate :ensure_description_or_media_present, on: :create
  validates :description, presence: true, on: :update

  scope :without_personal, -> { where(personal: false) }

  private

  def ensure_description_or_media_present
    return if description.present? || media.present?
    errors.add(:description, :blank_content)
    errors.add(:media, :blank_content)
  end
end
