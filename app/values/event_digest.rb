class EventDigest
  attr_accessor :event, :comment_notifications
  delegate :start_at, to: :event

  def initialize(event)
    self.event = event
    self.comment_notifications = []
  end

  def <<(system_notification)
    case system_notification.notification_type
      when /event_published|event_canceled/ then # noop
      when 'new_comment' then comment_notifications << system_notification
      else raise "Unknown notification type: #{system_notification.notification_type}"
    end
  end

  def ==(obj)
    obj.event == event
  end

  def eql?(obj)
    self == obj
  end

  delegate :hash, to: :event
end
