class SendNotification
  def initialize(options = {})
    @message = options.fetch(:message)
    @course = options.fetch(:course)
    @users = @course.students
    #@sms_provider = SmsProvider.new
    @email_provider = NotificationMailer
  end

  def send!
    Notification.create!(message: @message, course: @course)
    #@sms_provider.notify(message: sms_message, to: @users.map(&:phone_number))
    @email_provider.notify(
      message: @message,
      to: @users.map(&:email),
      subject: email_subject
    ).deliver
  end

  private

    def sms_message
      "[Dunno] #{@course.name} - #{@message}"
    end

    def email_subject
      "Professor(a) #{@course.teacher.name} da turma de #{@course.name} enviou uma mensagem"
    end
end
