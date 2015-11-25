class CourseDigest
  attr_accessor :course, :events, :blocked_notifications, :member_notifications
  delegate :order, to: :course

  def initialize(course)
    self.course = course
    self.events = Set.new
    self.blocked_notifications = []
    self.member_notifications = []
  end

  def <<(system_notification)
    case system_notification.notification_type
    when 'blocked' then blocked_notifications << system_notification
    when 'new_member' then @member_notifications << system_notification
    else
      event_digest_for(system_notification) << system_notification
    end
  end

  def events
    @events.sort_by(&:start_at)
  end

  def ==(other)
    other.course == course
  end

  def eql?(other)
    self == other
  end

  delegate :hash, to: :course

  def member_notifications
    @member_notifications.uniq(&:author)
  end

  private

  def event_for(system_notification)
    notifiable = system_notification.notifiable
    case notifiable
    when Event then notifiable
    when Comment, Topic then notifiable.event
    else raise "Unknown notifiable type: #{notifiable.inspect}"
    end
  end

  def event_digest_for(system_notification)
    event_digest = EventDigest.new(event_for system_notification)
    @events << event_digest
    @events.detect { |e| e == event_digest }
  end
end
