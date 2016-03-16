class EventDigest
  attr_accessor :event, :status_notifications, :comment_notifications, :topic_notifications
  delegate :start_at, to: :event

  def initialize(event)
    self.event = event
    self.status_notifications = []
    self.comment_notifications = []
    self.topic_notifications = []
  end

  def <<(system_notification)
    case system_notification.notification_type
    when /event_published|event_canceled/ then @status_notifications << system_notification
    when 'new_comment' then comment_notifications << system_notification
    when 'new_topic' then topic_notifications << system_notification
    else raise "Unknown notification type #{system_notification.notification_type} for #{system_notification.inspect}"
    end
  end

  def ==(other)
    other.event == event
  end

  def eql?(other)
    self == other
  end

  delegate :hash, :status, :start_at, to: :event

  def status_notifications
    Array(@status_notifications.sort_by(&:created_at).last)
  end

  def topic_notifications
    status_notifications.any? ? [] : @topic_notifications
  end

  def topics
    if status_notifications.any?
      event.topics.without_personal
    else
      topic_notifications.map(&:notifiable)
    end
  end
end
