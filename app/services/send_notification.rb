class SendNotification
  def initialize(options = {})
    @original_message = options.fetch(:message)
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
    @notification ||= Notification.new(message: @original_message, course: @course)
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

  def message
    "[Dunno] #{@course.abbreviation} - #{@original_message}"
  end

  def email_subject
    "[Dunno] Notificação de #{@course.abbreviation}"
  end

  def send_sms
    SmsProvider.new.notify(message: NotificationFormatter.format(message), to: @users.map(&:phone_number))
  rescue => e
    Rails.logger.error e.backtrace
    @errors[:sms] = { send: true }
  end

  def send_email
    NotificationMailer.notify(
      message: message,
      to: @users.map(&:email),
      subject: email_subject
    ).deliver
  rescue => e
    Rails.logger.error e.backtrace
    @errors[:email] = { send: true }
  end
end
