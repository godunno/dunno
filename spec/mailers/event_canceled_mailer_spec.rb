require 'spec_helper'

RSpec.describe EventCanceledMailer, type: :mailer do
  let(:teacher) { create(:profile) }
  let(:student) { create(:profile) }
  let(:course) { create(:course, teacher: teacher, students: [student]) }
  let(:event) { create(:event, course: course, start_at: Time.zone.parse('2015-01-01 14:00')) }

  before do
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
    EventCanceledMailer.event_canceled_email(event).deliver
  end

  after do
    ActionMailer::Base.deliveries.clear
  end

  it { expect(ActionMailer::Base.deliveries.count).to eq 1 }

  let(:email) { ActionMailer::Base.deliveries.first }

  it { expect(email.to).to match_array [student.email, teacher.email] }
  it { expect(email.subject).to eq "[Dunno] Aula cancelada: #{course.name} - Quinta (01/Jan – 14:00)" }
  it { expect(email.from).to eq ['contato@dunnoapp.com'] }
  it { expect(email.body).to include course.name }
  it { expect(email.body).to include 'Quinta (01/Jan – 14:00' }
end
