class EventStatusNotification
  def initialize(event, author)
    self.event = event
    self.author = author
  end

  def deliver
    case new_status
    when "canceled" then deliver_with_status(:event_canceled)
    when "published" then deliver_with_status(:event_published)
    end
  end

  private

  attr_accessor :event, :author

  def new_status
    _old_status, @new_status = event.previous_changes["status"]
    @new_status
  end

  def deliver_with_status(status)
    DeliverSystemNotifications.new(
      notifiable: event,
      notification_type: status,
      course: event.course,
      author: author
    ).deliver
  end
end
