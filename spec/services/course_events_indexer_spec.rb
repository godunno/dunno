require 'spec_helper'

describe CourseEventsIndexer, :elasticsearch do
  let(:weekly_schedule) { create(:weekly_schedule, weekday: 1, start_time: '09:00') }
  let(:event) { create(:event, start_at: fifth_date, status: 'published') }
  let(:course) { create(:course, weekly_schedules: [weekly_schedule], events: [event], start_date: Date.parse('2015-08-01'), end_date: '2015-08-31') }
  let(:first_date) { Time.zone.parse('2015-08-03 09:00') }
  let(:second_date) { Time.zone.parse('2015-08-10 09:00') }
  let(:third_date) { Time.zone.parse('2015-08-17 09:00') }
  let(:fourth_date) { Time.zone.parse('2015-08-24 09:00') }
  let(:fifth_date) { Time.zone.parse('2015-08-31 09:00') }
  before do
    CourseEventsIndexer.index!(course)
    Event.__elasticsearch__.refresh_index!
  end

  subject do
    SearchEventsByCourse.search(course, {})
  end

  it do
    event_dates = subject
                .map { |event| event.start_at.to_time }
                .sort
    expect(event_dates).to eq([first_date, second_date, third_date, fourth_date, fifth_date])
  end

  it do
    event_orders = subject
                .map(&:order)
                .sort
    expect(event_orders).to eq (1..5).to_a
  end
end
