class NewTopicNotification
  def initialize(topic, author)
    self.topic = topic
    self.author = author
  end

  def deliver
    return unless event.published?
    DeliverSystemNotifications.new(
      notifiable: topic,
      notification_type: 'new_topic',
      course: event.course,
      author: author
    ).deliver
  end

  private

  attr_accessor :topic, :author
  delegate :event, to: :topic
end
