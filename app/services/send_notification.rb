class SendNotification
  def initialize(options = {})
    self.message = options.fetch(:message)
    self.course = options.fetch(:course)
    self.users = course.try(:students) || []
  end

  def call
    notification.save!
    users.each do |user|
      send_email(user.email)
    end
  end

  def notification
    @notification ||= Notification.new(message: message, course: course)
  end

  private

  attr_accessor :message, :course, :users

  def email_subject
    "Dunno - Notificação da disciplina #{course.name}"
  end

  def send_email(email)
    NotificationMailer.delay.notify(
      course: course,
      message: message,
      to: email,
      subject: email_subject
    )
  end
end
