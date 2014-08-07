require 'spec_helper'

describe SendNotification do
  let(:users) do
    [
      create(:student, email: 'user1@email.com', phone_number: '+55 21 9999 9997'),
      create(:student, email: 'user2@email.com', phone_number: '+55 21 9999 9998'),
      create(:student, email: 'user3@email.com', phone_number: '+55 21 9999 9999')
    ]
  end

  let(:message) { "MESSAGE" }
  let(:course) { create(:course, students: users) }
  let(:teacher) { course.teacher }
  let(:sms_provider) { double("sms_provider", notify: nil) }
  let(:mail) { double("mail", deliver: nil) }

  before do
    SmsProvider.stub(:new).and_return(sms_provider)
    NotificationMailer.stub(:notify).and_return(mail)
  end

  it "should notify all users with SMS" do
    SmsProvider.stub(:new).and_return(sms_provider)
    expect(sms_provider).to receive(:notify).with(
      message: "[Dunno] #{course.name} - #{message}",
      to: users.map(&:phone_number)
    )
    SendNotification.new(message: message, course: course).send!
  end

  it "should notify all users with e-mail" do
    expect(NotificationMailer).to receive(:notify).with(
      message: message,
      subject: "Professor(a) #{teacher.name} da turma de #{course.name} enviou uma mensagem",
      to: users.map(&:email)
    ).and_return(mail)
    expect(mail).to receive(:deliver)

    SendNotification.new(message: message, course: course).send!
  end

  it "should record the notification" do
    SendNotification.new(message: message, course: course).send!
    last_notification = Notification.last
    expect(last_notification.message).to eq(message)
    expect(last_notification.course).to eq(course)
  end
end
