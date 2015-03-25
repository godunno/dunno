require 'spec_helper'

describe SendNotification do
  let(:users) do
    3.times.map { create(:student) }
  end

  let(:message) { "MESSAGE" }
  let(:course) { create(:course, students: users) }
  let(:teacher) { course.teacher }
  let(:sms_provider) { double("sms_provider", notify: nil) }
  let(:mail) { double("mail", deliver: nil) }

  before do
    SmsProvider.stub(:new).and_return(sms_provider)
    allow(NotificationMailer).to receive(:notify).and_return(mail)
  end

  it "should notify all users with SMS" do
    SmsProvider.stub(:new).and_return(sms_provider)
    expect(sms_provider).to receive(:notify).with(
      message: "[Dunno] #{course.abbreviation} - #{message}",
      to: users.map(&:phone_number)
    )
    SendNotification.new(message: message, course: course).call
  end

  it "should notify all users with e-mail" do
    expect(NotificationMailer).to receive(:notify).with(
      message: "[Dunno] #{course.abbreviation} - #{message}",
      subject: "[Dunno] Notificação de #{course.abbreviation}",
      to: users.map(&:email)
    ).and_return(mail)
    expect(mail).to receive(:deliver)

    SendNotification.new(message: message, course: course).call
  end

  it "should record the notification" do
    SendNotification.new(message: message, course: course).call
    last_notification = Notification.last
    expect(last_notification.message).to eq(message)
    expect(last_notification.course).to eq(course)
  end

  it "should show providers errors" do
    allow(sms_provider).to receive(:notify).and_raise("Error")
    allow(mail).to receive(:deliver).and_raise("Error")
    send_notification = SendNotification.new(message: message, course: course)
    send_notification.call
    expect(send_notification.valid?).to eq(false)
    expect(send_notification.errors).to eq(
      email: { send: true },
      sms:   { send: true }
    )
  end

  it "should show model errors" do
    send_notification = SendNotification.new(message: '', course: course)
    send_notification.call
    expect(send_notification.valid?).to eq(false)
    expect(send_notification.errors).to eq(
      message: {
        blank: true,
        too_short: true
      }
    )
  end

  it "should not try to send with providers when model is invalid" do
    send_notification = SendNotification.new(message: '', course: course)
    send_notification.call
    expect(sms_provider).not_to have_received(:notify)
    expect(mail).not_to have_received(:deliver)
  end
end
