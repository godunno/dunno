require 'spec_helper'

describe SmsProvider do

  let(:message) { 'MESSAGE' }
  let(:phone_numbers) { ["+55 21 99999999", "+55 21 99999998", "+55 21 99999997"] }
  let(:twilio_number) { '+55 21 1111 1111' }
  let(:account_sid) { '2389h879c2cbh236c' }
  let(:auth_token) { '20v25n27bv92yvcbhe29b' }

  context "sending message" do
    let(:twilio_client) { double(:twilio_client) }
    let(:twilio_messages) { double(:twilio_messages) }
    before do
      stub_const('ENV', {
        'TWILIO_PHONE_NUMBER' => twilio_number,
        'TWILIO_ACCOUNT_SID'  => account_sid,
        'TWILIO_AUTH_TOKEN'   => auth_token
      })
      expect(Twilio::REST::Client).to receive(:new).with(account_sid, auth_token).and_return(twilio_client)
      allow(twilio_client).to receive_message_chain(:account, :messages).and_return(twilio_messages)
    end

    it "should send a message to all phone numbers" do
      phone_numbers.each do |phone_number|
        expect(twilio_messages).to receive(:create).with(to: phone_number, body: message, from: twilio_number)
      end
      SmsProvider.new.notify(message: message, to: phone_numbers)
    end

    it "should use the formatter for each number" do
      allow(twilio_messages).to receive(:create)
      formatter = spy("PhoneFormatter")
      allow(PhoneFormatter).to receive(:new).and_return(formatter)
      SmsProvider.new.notify(message: message, to: phone_numbers)
      expect(formatter).to have_received(:format).exactly(phone_numbers.length).times
    end
  end

  context "trying to send message when unconfigured" do
    it "should fail silently" do
      stub_const('ENV', {
        'TWILIO_PHONE_NUMBER' => nil,
        'TWILIO_ACCOUNT_SID'  => nil,
        'TWILIO_AUTH_TOKEN'   => nil,
      })

      expect do
        SmsProvider.new.notify(message: message, to: phone_numbers)
      end.not_to raise_error
    end
  end
end
