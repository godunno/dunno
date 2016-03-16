class Comment < ActiveRecord::Base
  belongs_to :profile
  belongs_to :event
  has_many :attachments, dependent: :destroy
  has_many :system_notifications, dependent: :destroy, as: :notifiable

  validates :profile, :event, :body, presence: true

  default_scope { order(created_at: :asc) }

  def event_start_at
    event.start_at
  end

  def removed?
    removed_at.present?
  end

  def blocked?
    blocked_at.present?
  end
end
