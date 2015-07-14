class SmsProvider
  def initialize
    # TODO: This will fail silently if something bad happens to the client.
    # We should just disable this on test and dev environments.
    @client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN'] rescue nil
    @from = ENV['TWILIO_PHONE_NUMBER']
  end

  def notify(options)
    return unless @client
    body = NotificationFormatter.format options.fetch(:message)
    phone_numbers = [options.fetch(:to)].flatten

    phone_numbers.each do |phone_number|
      @client.account.messages.create(body: body, to: PhoneFormatter.format(phone_number), from: @from)
    end
  end
end
