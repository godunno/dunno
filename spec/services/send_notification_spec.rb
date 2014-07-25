require 'spec_helper'

class SmsProvider
  def notify(*args); end
end

class NotificationMailer
  def notify(*args); end
end

describe SendNotification do
  let(:users) do
    [
      stub(email: 'user1@email.com', phone_number: '+552199999997'),
      stub(email: 'user2@email.com', phone_number: '+552199999998'),
      stub(email: 'user3@email.com', phone_number: '+552199999999')
    ]
  end

  let(:message) { "MESSAGE" }
  let(:course) { stub(name: 'Calculus', students: users, teacher: teacher) }
  let(:teacher) { stub(name: 'John Doe') }

  it "should notify all users with SMS" do
    SmsProvider.stub(:new).and_return(sms_provider = stub)
    expect(sms_provider).to receive(:notify).with(
      message: "[Dunno] #{course.name} - #{message}",
      to: users.map(&:phone_number)
    )
    SendNotification.new(message: message, course: course).send!
  end

  it "should notify all users with e-mail" do
    NotificationMailer.stub(:new).and_return(email_provider = stub)
    expect(email_provider).to receive(:notify).with(
      message: message,
      subject: "Professor(a) #{teacher.name} da turma de #{course.name} enviou uma mensagem",
      to: users.map(&:email)
    )
    SendNotification.new(message: message, course: course).send!
  end
end
