require 'spec_helper'

describe EventService do
  before { Timecop.freeze Time.zone.local(2015, 7, 20, 18, 00) }
  after { Timecop.return }

  let!(:course) { create(:course, start_date: nil, end_date: nil) }
  let!(:weekly_schedule) { create(:weekly_schedule, course: course, classroom: '1A', start_time: '09:00', end_time: '11:00') }
  let(:service) { EventService.new(course, nil) }
  let(:events) { service.events }
  let(:next_month_events) { EventService.new(course, 1.month.from_now).events }
  let(:next_year_events) { EventService.new(course, 1.year.from_now).events }

  context 'with no events already created' do
    it "starts counting by when the course was created by default" do
      expect(next_month_events.size).to be 5
    end

    it "starts on the date the course was created by default" do
      expect(events.first.order).to be 1
    end

    it "has all events on next year" do
      expect(next_year_events.size).to be 4
    end

    it "starts in the right time for the weekly schedule" do
      expect(TimeOfDay(events.first.start_at)).to eq TimeOfDay.parse(weekly_schedule.start_time)
    end

    describe "paginating" do
      it { expect(service.next_month).to eq 1.month.from_now.beginning_of_month }
      it { expect(service.previous_month).to eq 1.month.ago.beginning_of_month }
      it { expect(service.current_month).to eq Time.current.beginning_of_month }
    end

    context "concerning non-persisted events" do
      subject { events.first }

      it { is_expected.to be_a Event }
      it { expect(subject.course).to eq course }
      it { expect(subject.classroom).to eq weekly_schedule.classroom }
      it { expect(subject.start_at).to eq Time.zone.local(2015, 7, 27, 9, 00)  }
      it { expect(subject.end_at).to eq Time.zone.local(2015, 7, 27, 11, 00)  }
    end

    context "with a start date set on course" do
      let!(:course) { create(:course, start_date: 1.month.ago, end_date: nil) }

      it 'starts counting from the course start date' do
        expect(events.first.order).to eq 3
      end
    end

    context "with an end date set on course" do
      let!(:course) { create(:course, start_date: nil, end_date: 2.month.from_now) }

      it 'stops creating occurrences using the course end date' do
        events_out_of_range = EventService.new(course, 3.months.from_now).events
        expect(events_out_of_range).to be_empty
      end
    end

    context "with more than one weekly schedule" do
      let!(:other_weekly_schedule) { create(:weekly_schedule, weekday: 5, course: course) }

      it "has occurrences for both weekly schedules" do
        expect(events.size).to eq 3
      end
    end

    context "counting" do
      it "starts counting by when the course was created by default" do
        expect(next_month_events.first.order).to be 2
      end
    end
  end

  context 'with events already created' do
    context 'for events in the weekly schedule' do
      let!(:event) { create(:event, course: course, start_at: Time.zone.local(2015, 7, 27, 9, 0, 0)) }

      it "uses real events if they are already created" do
        expect(events.first).to eq event
      end
    end

    context 'for events outside the weekly schedule' do
      let!(:event) { create(:event, course: course, start_at: Time.zone.local(2015, 7, 27, 8, 0, 0)) }

      it "uses real events if they are already created" do
        expect(events.first).to eq event
      end

      it "has an order attribute" do
        expect(events.first.order).to be_present
      end
    end

    context "when there's no weekly schedules" do
      let!(:event) { create(:event, course: course, start_at: Time.zone.local(2015, 7, 27, 8, 0, 0)) }
      before do
        weekly_schedule.destroy!
      end

      it { expect(events.first).to eq event }
    end
  end
end
