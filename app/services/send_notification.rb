class SendNotification
  def initialize(options = {})
    @original_message = options.fetch(:message)
    @course = options.fetch(:course)
    @users = @course.try(:students) || []
  end

  def call
    return unless notification.save!
    send_sms
    send_email
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

  def send_sms
    @users.each { |user| SmsNotificationWorker.perform_async(message, user.phone_number) }
  end

  def send_email
    NotificationMailer.notify(
      message: message,
      to: @users.map(&:email),
      subject: email_subject
    ).deliver
  end
end
