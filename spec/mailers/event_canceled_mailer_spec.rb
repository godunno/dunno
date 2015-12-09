require 'spec_helper'

RSpec.describe EventCanceledMailer, type: :mailer do
  let(:profile) { create(:profile) }
  let(:course) { create(:course) }
  let(:event) { create(:event, course: course, start_at: Time.zone.parse('2015-01-01 14:00')) }

  before do
    EventCanceledMailer.event_canceled_email(event.id, profile.id).deliver
  end

  after do
    ActionMailer::Base.deliveries.clear
  end

  it { expect(ActionMailer::Base.deliveries.count).to eq 1 }

  let(:email) { ActionMailer::Base.deliveries.first }

  it { expect(email.to).to match_array [profile.email] }
  it do
    expect(email.subject).to eq(
      "[Dunno] Aula cancelada: #{course.name} - Quinta (01/Jan – 14:00)"
    )
  end
  it { expect(email.from).to eq ['contato@dunnoapp.com'] }
  it { expect(email.body).to include course.name }
  it { expect(email.body).to include 'Quinta (01/Jan – 14:00)' }
end
