class NotificationMailer < ActionMailer::Base
  include Roadie::Rails::Automatic

  layout 'email'

  def notify(options)
    emails = options.fetch(:to)
    subject = options.fetch(:subject)

    @message = options.fetch(:message)
    @course = options.fetch(:course)

    mail to: emails, subject: subject
  end
end
