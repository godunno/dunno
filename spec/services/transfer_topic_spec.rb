require 'spec_helper'

describe TransferTopic do
  let(:first_date)  { Time.zone.parse('2015-08-03 09:00') }
  let(:second_date) { Time.zone.parse('2015-08-10 09:00') }
  let(:third_date)  { Time.zone.parse('2015-08-17 09:00') }
  let(:fourth_date) { Time.zone.parse('2015-08-24 09:00') }
  let(:fifth_date)  { Time.zone.parse('2015-08-31 09:00') }
  let(:sixth_date)  { Time.zone.parse('2015-09-07 09:00') }

  before { Timecop.freeze first_date.beginning_of_month }
  after { Timecop.return }

  let(:course) { create(:course, start_date: first_date, end_date: sixth_date, weekly_schedules: [weekly_schedule]) }
  let(:weekly_schedule) { create(:weekly_schedule, weekday: 1, start_time: '09:00', end_time: '11:00') }
  let(:topic) { create(:topic, event: event) }
  let(:event) { create(:event, course: course, start_at: first_date) }
  let(:service) { TransferTopic.new(topic) }

  context "next event is persisted" do
    let!(:next_event) { create(:event, course: course, start_at: second_date) }

    it { expect(service.transfer).to be true }
    it do
      expect     { service.transfer }
      .to change { topic.reload.event }
      .from(event)
      .to(next_event)
    end
  end

  context "next event isn't persisted" do
    it { expect(service.transfer).to be true }
    it do
      service.transfer
      new_event = topic.reload.event
      expect(new_event).to be_persisted
      expect(new_event.start_at).to eq second_date
    end
  end

  context "there's no next event" do
    let(:event) { create(:event, course: course, start_at: sixth_date) }

    it { expect(service.transfer).to be false }
    it do
      expect { service.transfer }.not_to change { topic.reload.event }
    end
  end

  context "next event is canceled" do
    let!(:next_event) { create(:event, status: 'canceled', course: course, start_at: second_date) }

    it { expect(service.transfer).to be true }
    it do
      service.transfer
      new_event = topic.reload.event
      expect(new_event).to be_persisted
      expect(new_event.start_at).to eq third_date
    end
  end

  context "next two events are canceled" do
    let!(:second_event) { create(:event, status: 'canceled', course: course, start_at: second_date) }
    let!(:third_event) { create(:event, status: 'canceled', course: course, start_at: third_date) }

    it { expect(service.transfer).to be true }
    it do
      service.transfer
      new_event = topic.reload.event
      expect(new_event).to be_persisted
      expect(new_event.start_at).to eq fourth_date
    end
  end

  context "all future events are canceled" do
    before do
      [second_date, third_date, fourth_date, fifth_date, sixth_date].each do |date|
        create(:event, status: 'canceled', course: course, start_at: date)
      end
    end

    it { expect(service.transfer).to be false }
    it do
      expect { service.transfer }.not_to change { topic.reload.event }
    end
  end

  context "next event is in the next month" do
    let(:event) { create(:event, course: course, start_at: fifth_date) }

    it { expect(service.transfer).to be true }
    it do
      service.transfer
      new_event = topic.reload.event
      expect(new_event).to be_persisted
      expect(new_event.start_at).to eq sixth_date
    end
  end
end
