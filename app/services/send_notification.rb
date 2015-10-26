class SendNotification
  def initialize(options = {})
    @original_message = options.fetch(:message)
    @course = options.fetch(:course)
    @users = @course.try(:students) || []
  end

  def call
    notification.save!
    @users.each do |user|
      send_email(user.email)
    end
  end

  def notification
    @notification ||= Notification.new(message: @original_message, course: @course)
  end

  private

  def message
    "Mensagem de #{@course.teacher.name}\nDisciplina: #{@course.name}\n\nMensagem: #{@original_message}"
  end

  def email_subject
    "Dunno - Notificação da disciplina #{@course.name}"
  end

  def send_email(email)
    NotificationMailer.delay.notify(
      message: message,
      to: email,
      subject: email_subject
    )
  end
end
