class NewCommentNotification
  def initialize(comment, author)
    self.comment = comment
    self.author = author
  end

  def deliver
    DeliverSystemNotifications.new(
      notifiable: comment,
      notification_type: :new_comment,
      course: comment.event.course,
      author: author
    ).deliver
  end

  private

  attr_accessor :comment, :author
end
