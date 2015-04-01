class SmsNotificationWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'sms', retry: false

  def perform(message, phone_number)
    SmsProvider.new.notify(message: message, to: phone_number)
  end
end
