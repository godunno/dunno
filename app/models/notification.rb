class Notification < ActiveRecord::Base
  belongs_to :course

  validates :course, presence: true
  validates :message, presence: true
  validate :repeated_message

  private

  def repeated_message
    last_notification = course && course.notifications.order(created_at: :desc).first
    return unless last_notification.present?
    errors.add(:message, :repeated) if message == last_notification.message
  end
end
