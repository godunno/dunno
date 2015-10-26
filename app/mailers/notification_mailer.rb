class NotificationMailer < ActionMailer::Base
  include Roadie::Rails::Automatic

  layout 'email'

  def notify(options)
    emails = options.fetch(:to)
    body = options.fetch(:message)
    subject = options.fetch(:subject)

    mail to: emails, body: body, subject: subject
  end
end
