require 'spec_helper'

describe FindOrInitializeEvent do
  let(:course) { create(:course, weekly_schedules: [weekly_schedule]) }
  let(:weekly_schedule) { create(:weekly_schedule, weekday: 1, start_time: '09:00', end_time: '11:00', classroom: 'A-2', created_at: 1.minute.from_now) }

  context "finding event" do
    let!(:event) { create(:event, course: course, start_at: Time.zone.local(2015, 7, 20, 9, 0, 0, 12345)) }
    subject { FindOrInitializeEvent.by(course, start_at: event.start_at.utc.iso8601) }

    it { expect(subject).to eq event }
  end

  context "initializing event" do
    let(:start_at) { Time.zone.local(2015, 7, 27, 9) }
    subject { FindOrInitializeEvent.by(course, start_at: start_at.utc.iso8601) }

    it { expect(subject.start_at).to eq start_at }
  end
end
