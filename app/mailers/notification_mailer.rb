class NotificationMailer < ActionMailer::Base
  def notify(options)
    emails = options.fetch(:to)
    body = options.fetch(:message)
    subject = options.fetch(:subject)

    mail(to: emails, body: body, subject: subject)
  end
end
