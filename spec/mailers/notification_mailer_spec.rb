require 'spec_helper'

describe NotificationMailer do
  let(:message) { "MESSAGE" }
  let(:course) { create(:course) }
  let(:recipients) { %w(user1@email.com user2@email.com user3@email.com) }
  let(:subj) { "SUBJECT" }

  before do
    NotificationMailer.notify(
      message: message,
      course: course,
      to: recipients,
      subject: subj
    ).deliver
  end

  after do
    ActionMailer::Base.deliveries.clear
  end

  it { expect(ActionMailer::Base.deliveries.count).to eq 1 }

  subject { ActionMailer::Base.deliveries.first }

  it { expect(subject.to).to eq recipients }
  it { expect(subject.body.raw_source).to include message }
  it { expect(subject.subject).to eq subj }
  it { expect(subject.from).to eq ['contato@dunnoapp.com'] }
end
