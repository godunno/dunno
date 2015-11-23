class DeliverSystemNotifications
  def initialize(options)
    self.notifiable = options.fetch(:notifiable)
    self.notification_type = options.fetch(:notification_type)
    self.course = options.fetch(:course)
    self.author = options.fetch(:author)
  end

  def deliver
    course.memberships.where.not(role: 'blocked').find_each do |membership|
      SystemNotification.create!(
        profile: membership.profile,
        author: author,
        notifiable: notifiable,
        notification_type: notification_type
      )
    end
  end

  private

  attr_accessor :notifiable, :notification_type, :course, :author
end
