require 'spec_helper'

describe NotifyEventCanceledMail do
  let(:course) { create(:course, teacher: teacher, students: [student]) }
  let(:event) { create(:event, course: course) }
  let(:teacher) { create(:profile) }
  let(:student) { create(:profile) }

  let(:service) { NotifyEventCanceledMail.new(event) }
  let(:delayed_mailer) { double("Delayed Mailer", event_canceled_email: nil) }

  before do
    allow(EventCanceledMailer).to receive(:delay).and_return(delayed_mailer)
  end

  it "delivers for teacher" do
    service.deliver
    expect(delayed_mailer)
      .to have_received(:event_canceled_email)
      .with(event.id, teacher.id)
  end

  it "delivers for students" do
    service.deliver
    expect(delayed_mailer)
      .to have_received(:event_canceled_email)
      .with(event.id, student.id)
  end
end
