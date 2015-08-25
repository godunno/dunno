require 'spec_helper'

describe EventsForPeriod do
  let(:first_date) { Time.zone.parse('2015-08-03 09:00') }
  let(:second_date) { Time.zone.parse('2015-08-10 09:00') }
  let(:third_date) { Time.zone.parse('2015-08-17 09:00') }
  let(:fourth_date) { Time.zone.parse('2015-08-24 09:00') }
  let(:fifth_date) { Time.zone.parse('2015-08-31 09:00') }

  let(:weekly_schedule) { create(:weekly_schedule, weekday: 1, start_time: '09:00', end_time: '11:00') }
  let(:course) { create(:course, weekly_schedules: [weekly_schedule], start_date: first_date - 2.months, end_date: first_date + 2.months) }
  let(:service) { EventsForPeriod.new(course, WholePeriod.new(today).month) }

  before do
    Timecop.travel today
    PersistPastEvents.new(course, since: course.start_date).persist!
    weekly_schedule.update!(start_time: '16:00', end_time: '18:00')
    course.reload
  end

  after { Timecop.return }

  subject { service.events }

  context "two days before event" do
    let(:today) { second_date - 2.day }

    it { expect(subject.count).to eq 5 }
    it { expect(subject.first(1).all?(&:persisted?)).to be true }
    it { expect(subject.last(4).any?(&:persisted?)).to be false }
  end

  context "day before event" do
    let(:today) { second_date - 1.day }

    it { expect(subject.count).to eq 5 }
    it { expect(subject.first(2).all?(&:persisted?)).to be true }
    it { expect(subject.last(3).any?(&:persisted?)).to be false }
  end

  context "whole range after today" do
    let(:today) { second_date }
    let(:service) { EventsForPeriod.new(course, WholePeriod.new(today + 1.month).month) }

    it { expect(subject.count).to eq 4 }
    it { expect(subject.any?(&:persisted?)).to be false }
  end

  context "whole range before today" do
    let(:today) { second_date }
    let(:service) { EventsForPeriod.new(course, WholePeriod.new(today - 1.month).month) }

    it { expect(subject.count).to eq 4 }
    it { expect(subject.all?(&:persisted?)).to be true }
  end
end
