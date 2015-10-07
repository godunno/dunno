class SystemNotification < ActiveRecord::Base
  enum notification_type: %w(event_canceled event_published new_comment)

  belongs_to :author, class_name: 'Profile'
  belongs_to :profile
  belongs_to :notifiable, polymorphic: true

  validates :author, :profile, :notifiable, :notification_type, presence: true
end
