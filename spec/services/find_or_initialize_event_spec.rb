require 'spec_helper'

describe FindOrInitializeEvent do
  let(:course) { create(:course, weekly_schedules: [weekly_schedule]) }
  let(:weekly_schedule) { create(:weekly_schedule, weekday: 1, start_time: '09:00', end_time: '11:00', classroom: 'A-2', created_at: 1.minute.from_now) }
  let(:service) { FindOrInitializeEvent.new(course) }

  context "finding event" do
    let!(:event) { create(:event, course: course, start_at: Time.zone.local(2015, 7, 20, 9)) }
    subject { service.by({ start_at: event.start_at.utc.iso8601 }, 8) }

    it { expect(subject).to eq event }
    it { expect(subject.order).to eq 8 }
  end

  context "initializing event" do
    let(:start_at) { Time.zone.local(2015, 7, 27, 9) }
    subject { service.by({ start_at: start_at.utc.iso8601 }, 9) }

    it { expect(subject.start_at).to eq start_at }
    it { expect(subject.order).to eq 9 }
  end
end
