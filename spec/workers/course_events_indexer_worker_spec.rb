require 'spec_helper'

describe CourseEventsIndexerWorker, :elasticsearch do
  let(:weekly_schedule) { create(:weekly_schedule, weekday: 1, start_time: '09:00') }
  let(:event) { create(:event, start_at: fifth_date, status: 'published') }
  let(:course) { create(:course, weekly_schedules: [weekly_schedule], events: [event], start_date: '2015-08-01', end_date: '2015-08-31') }
  let(:first_date) { Time.zone.parse('2015-08-03 09:00') }
  let(:second_date) { Time.zone.parse('2015-08-10 09:00') }
  let(:third_date) { Time.zone.parse('2015-08-17 09:00') }
  let(:fourth_date) { Time.zone.parse('2015-08-24 09:00') }
  let(:fifth_date) { Time.zone.parse('2015-08-31 09:00') }

  before do
    CourseEventsIndexerWorker.new.perform(course.id)
    Event.__elasticsearch__.refresh_index!
  end

  subject do
    SearchEventsByCourse.search(course, {})
  end

  it do
    event_dates = subject
                .map { |event| event.start_at.to_time }
                .sort
    expect(event_dates).to eq([first_date, second_date, third_date, fourth_date, event.start_at])
  end

  context "when course doesn't have end_date" do
    let(:course) { create(:course, weekly_schedules: [weekly_schedule], start_date: '2015-08-01', end_date: nil) }

    context "and it has a published event" do
      let!(:event) { create(:event, course: course, start_at: second_date, status: 'published') }
      it do
        event_dates = subject
                    .map { |event| event.start_at.to_time }
                    .sort
        expect(event_dates).to eq([first_date, event.start_at])
      end
    end

    context "and it doesn't have any published event" do
      let(:sixth_date) { Time.zone.parse('2015-09-07 09:00') }
      before { Timecop.travel sixth_date }
      after { Timecop.return }

      before do
        CourseEventsIndexerWorker.new.perform(course.id)
        Event.__elasticsearch__.refresh_index!
      end

      it "indexes events until today" do
        event_dates = subject
                    .map { |event| event.start_at.to_time }
                    .sort
        expect(event_dates).to eq([first_date, second_date, third_date, fourth_date, fifth_date, sixth_date])
      end
    end

  end

  context "deleting old documents" do
    before do
      weekly_schedule.update!(weekday: 2)
      CourseEventsIndexerWorker.new.perform(course.id)
      Event.__elasticsearch__.refresh_index!
    end

    it do
      event_dates = subject
                      .map { |event| event.start_at.to_time }
                      .sort
      expect(event_dates).to eq([first_date + 1.day, second_date + 1.day, third_date + 1.day, fourth_date + 1.day, event.start_at])
    end
  end
end
