class SendNotification
  def initialize(options = {})
    @message = options.fetch(:message)
    @course = options.fetch(:course)
    @users = @course.try(:students) || []
    @errors = {}
  end

  def call
    return unless notification.save
    send_sms
    send_email
  end

  def notification
    @notification ||= Notification.new(message: @message, course: @course)
  end

  def errors
    notification.errors.details.each do |attribute, errors|
      @errors[attribute] ||= {}
      errors.each { |error| @errors[attribute][error[:error]] = true }
    end
    @errors
  end

  def valid?
    errors.empty?
  end

  private

  def sms_message
    "[Dunno] #{@course.name} - #{@message}"
  end

  def email_subject
    "Professor(a) #{@course.teacher.name} da turma de #{@course.name} enviou uma mensagem"
  end

  def send_sms
    SmsProvider.new.notify(message: sms_message, to: @users.map(&:phone_number))
  rescue
    @errors[:sms] = { send: true }
  end

  def send_email
    NotificationMailer.notify(
      message: @message,
      to: @users.map(&:email),
      subject: email_subject
    ).deliver
  rescue
    @errors[:email] = { send: true }
  end
end
