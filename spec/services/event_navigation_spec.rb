require 'spec_helper'

describe EventNavigation do
  let(:first_date)  { Time.zone.parse('2015-08-03 09:00') }
  let(:second_date) { Time.zone.parse('2015-08-10 09:00') }
  let(:third_date)  { Time.zone.parse('2015-08-17 09:00') }
  let(:fourth_date) { Time.zone.parse('2015-08-24 09:00') }
  let(:fifth_date)  { Time.zone.parse('2015-08-31 09:00') }

  before { Timecop.travel first_date.beginning_of_month }
  after { Timecop.return }

  let(:course) { create(:course, start_date: first_date, end_date: fifth_date, weekly_schedules: [weekly_schedule]) }
  let(:weekly_schedule) { create(:weekly_schedule, weekday: 1, start_time: '09:00') }
  let(:event) { build(:event, course: course, start_at: start_at) }
  let(:service) { EventNavigation.new(event) }

  context "event with previous and next" do
    let(:start_at) { second_date }

    it { expect(service.previous.start_at).to eq first_date }
    it { expect(service.next.start_at).to eq third_date }
  end

  context "first event" do
    let(:start_at) { first_date }

    it { expect(service.previous).to be_nil }
    it { expect(service.next.start_at).to eq second_date }
  end

  context "last event" do
    let(:start_at) { fifth_date }

    it { expect(service.previous.start_at).to eq fourth_date }
    it { expect(service.next).to be_nil }
  end

  context "when it starts in the next month and its course has no start_date and end_date" do
    let(:course) { create(:course, start_date: nil, end_date: nil, weekly_schedules: [weekly_schedule]) }
    let(:start_at) { fifth_date }
    let(:sixth_date)  { Time.zone.parse('2015-09-07 09:00') }

    before { Timecop.travel(first_date - 1.month) }
    after { Timecop.return }

    it { expect(service.previous.start_at).to eq fourth_date }
    it { expect(service.next.start_at).to eq sixth_date }
  end
end
