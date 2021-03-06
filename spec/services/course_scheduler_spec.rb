require 'spec_helper'

describe CourseScheduler do
  let(:course) { create(:course, end_date: nil) }
  let(:weekly_schedule) { create(:weekly_schedule, course: course, weekday: 1, classroom: '1A', start_time: '09:00', end_time: '11:00') }
  let(:service) { CourseScheduler.new(course, current_month) }
  let(:events) { service.events }
  let(:current_month) { Time.current.beginning_of_month..Time.current.end_of_month }
  let(:next_month) { 1.month.from_now.beginning_of_month..1.month.from_now.end_of_month }
  let(:month_in_next_year) { 1.year.from_now.beginning_of_month..1.year.from_now.end_of_month }
  let(:next_month_events) { CourseScheduler.new(course, next_month).events }
  let(:next_year_events) { CourseScheduler.new(course, month_in_next_year).events }

  before do
    Timecop.freeze Time.zone.parse('2015-07-21 18:00')
    weekly_schedule.save!
    course.reload
  end

  after { Timecop.return }

  context 'with no events already created' do
    it "starts counting by when the course was created by default" do
      expect(next_month_events.size).to be 5
    end

    it "has all events on next year" do
      expect(next_year_events.size).to be 4
    end

    it "starts in the right time for the weekly schedule" do
      expect(Tod::TimeOfDay(events.first.start_at)).to eq Tod::TimeOfDay.parse(weekly_schedule.start_time)
    end

    context "concerning non-persisted events" do
      subject { events.first }

      it { is_expected.to be_a Event }
      it { expect(subject.course).to eq course }
      it { expect(subject.classroom).to eq weekly_schedule.classroom }
      it { expect(subject.start_at).to eq Time.zone.parse('2015-07-27 09:00')  }
      it { expect(subject.end_at).to eq Time.zone.parse('2015-07-27 11:00')  }
    end

    context "with an end date set on course" do
      let!(:course) { create(:course, end_date: 2.month.from_now) }
      let(:three_months_from_now) { 3.months.from_now.beginning_of_month..3.months.from_now.end_of_month }

      it 'stops creating occurrences using the course end date' do
        events_out_of_range = CourseScheduler.new(course, three_months_from_now).events
        expect(events_out_of_range).to be_empty
      end
    end

    context "with more than one weekly schedule" do
      let!(:other_weekly_schedule) { create(:weekly_schedule, weekday: 5, course: course) }

      before { course.reload }

      it "has occurrences for both weekly schedules" do
        expect(events.size).to eq 3
      end
    end
  end

  context 'with events already created' do
    context 'for events in the weekly schedule' do
      let!(:event) { create(:event, course: course, start_at: Time.zone.parse('2015-07-27 09:00')) }

      it "uses real events if they are already created" do
        expect(events.first).to eq event
      end
    end

    context 'for events outside the weekly schedule' do
      let!(:event) { create(:event, course: course, start_at: Time.zone.parse('2015-07-27 08:00')) }

      it "uses real events if they are already created" do
        expect(events.first).to eq event
      end
    end

    context "when there's no weekly schedules" do
      let!(:event) { create(:event, course: course, start_at: Time.zone.parse('2015-07-27 08:00')) }
      before do
        weekly_schedule.destroy!
      end

      it { expect(events.first).to eq event }
    end
  end

  context "with an invalid range" do
    let(:service) { CourseScheduler.new(course, nil..nil) }

    it { expect(events).to eq [] }
  end
end
