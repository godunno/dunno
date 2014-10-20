class NotificationMailer < ActionMailer::Base
  default from: 'noreply@dunnoapp.com'

  def notify(options)
    bcc = options.fetch(:to)
    body = options.fetch(:message)
    subject = options.fetch(:subject)
    mail(bcc: bcc, body: body, subject: subject)
  end
end
