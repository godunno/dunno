require 'spec_helper'

describe SmsProvider do

  let(:message) { 'MESSAGE' }
  let(:phone_numbers) { %w(+552199999999 +552199999998 +552199999997) }
  let(:twilio_number) { '+552111111111' }
  let(:account_sid) { '2389h879c2cbh236c' }
  let(:auth_token) { '20v25n27bv92yvcbhe29b' }

  before do
    stub_const('ENV', {
      'TWILIO_PHONE_NUMBER' => twilio_number,
      'TWILIO_ACCOUNT_SID' => account_sid,
      'TWILIO_AUTH_TOKEN' => auth_token
    })
  end

  it "should send a message to all phone numbers" do
    expect(Twilio::REST::Client).to receive(:new).with(account_sid, auth_token).and_return(twilio_client = stub(:twilio_client))
    twilio_client.stub_chain(:account, :messages).and_return(twilio_messages = stub(:twilio_messages))

    phone_numbers.each do |phone_number|
      expect(twilio_messages).to receive(:create).with(to: phone_number, body: message, from: twilio_number)
    end
    SmsProvider.new.notify(message: message, to: phone_numbers)
  end
end
