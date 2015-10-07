class DeliverSystemNotifications
  def self.detect(record, author)
    case record
    when Event then detect_event_notification(record, author)
    when Comment then detect_comment_notification(record, author)
    else
      raise NoSystemNotificationForClass, "No SystemNotification available for #{record.inspect}"
    end
  end

  def self.detect_event_notification(event, author)
    _old_status, new_status = event.previous_changes["status"]
    case new_status
    when "canceled"
      new(notifiable: event,
          notification_type: :event_canceled,
          course: event.course,
          author: author)
    when "published"
      new(notifiable: event,
          notification_type: :event_published,
          course: event.course,
          author: author)
    else NullSendSystemNotification.new
    end
  end

  def self.detect_comment_notification(comment, author)
    old_id, new_id = comment.previous_changes["id"]
    is_new_record = old_id.nil? && new_id.present?
    if is_new_record
      new(notifiable: comment,
          notification_type: :new_comment,
          course: comment.event.course,
          author: author)
    else
      NullSendSystemNotification.new
    end
  end

  def initialize(options)
    self.notifiable        = options.fetch(:notifiable)
    self.notification_type = options.fetch(:notification_type)
    self.course            = options.fetch(:course)
    self.author            = options.fetch(:author)
  end

  def deliver
    course.memberships.find_each do |membership|
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

  class NullSendSystemNotification
    def deliver; end
  end

  class NoSystemNotificationForClass < StandardError; end
end
