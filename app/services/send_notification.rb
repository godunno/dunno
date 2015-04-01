class SendNotification
  def initialize(options = {})
    @original_message = options.fetch(:message)
    @course = options.fetch(:course)
    @users = @course.try(:students) || []
  end

  def call
    notification.save!
    @users.each do |user|
      send_sms(user.phone_number)
      send_email(user.email)
    end
  end

  def notification
    @notification ||= Notification.new(message: @original_message, course: @course)
  end

  private

  def message
    "[Dunno] #{@course.abbreviation} - #{@original_message}"
  end

  def email_subject
    "[Dunno] Notificação de #{@course.abbreviation}"
  end

  def send_sms(phone_number)
    SmsNotificationWorker.perform_async(message, phone_number)
  end

  def send_email(email)
    NotificationMailer.delay.notify(
      message: NotificationFormatter.format(message),
      to: email,
      subject: email_subject
    )
  end
end
