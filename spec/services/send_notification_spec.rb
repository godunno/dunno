require 'spec_helper'

describe SendNotification do
  let(:users) do
    3.times.map { create(:student) }
  end

  let(:message) { "MESSAGE" }
  let(:course) { create(:course, students: users) }
  let(:teacher) { course.teacher }
  let(:mail) { double("mail", deliver: nil) }

  before do
    allow(SmsNotificationWorker).to receive(:perform_async)
    allow(NotificationMailer).to receive(:notify).and_return(mail)
  end

  it "should notify all users with SMS" do
    complete_message = "[Dunno] #{course.abbreviation} - #{message}"
    users.each do |user|
      expect(SmsNotificationWorker).to receive(:perform_async).with(
        complete_message,
        user.phone_number
      )
    end
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

  it "should not send notification with providers when model is invalid" do
    send_notification = SendNotification.new(message: '', course: course)
    expect { send_notification.call }.to raise_error ActiveRecord::RecordInvalid
  end
end
