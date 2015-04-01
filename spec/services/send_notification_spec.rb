require 'spec_helper'

describe SendNotification do
  let(:users) do
    3.times.map { create(:student) }
  end

  let(:message) { "MESSAGE" }
  let(:course) { create(:course, students: users) }
  let(:complete_message) { "[Dunno] #{course.abbreviation} - #{message}" }
  let(:teacher) { course.teacher }
  let(:delayed_mailer) { double("Delayed Mailer", notify: nil) }

  before do
    allow(SmsNotificationWorker).to receive(:perform_async)
    allow(NotificationMailer).to receive(:delay).and_return(delayed_mailer)
  end

  it "should notify all users with SMS" do
    users.each do |user|
      expect(SmsNotificationWorker).to receive(:perform_async).with(
        complete_message,
        user.phone_number
      )
    end
    SendNotification.new(message: message, course: course).call
  end

  it "should notify all users with e-mail" do
    expect(NotificationFormatter).to receive(:format)
      .with(complete_message)
      .exactly(3)
      .times
      .and_return(complete_message)
    users.each do |user|
      expect(delayed_mailer).to receive(:notify).with(
        message: complete_message,
        subject: "[Dunno] Notificação de #{course.abbreviation}",
        to: user.email
      )
    end

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
