require 'spec_helper'

describe PersistPastEvents do
  let(:course) { create(:course, start_date: event_start_at - 1.day, end_date: event_start_at + 1.month) }
  let(:event_start_at) { Time.zone.parse('2015-08-01 09:00') }
  let!(:event) { create(:event, course: course, start_at: event_start_at) }
  let!(:yesterday_schedule) { create(:weekly_schedule, course: course, weekday: 6, start_time: "09:00") }
  let!(:today_schedule) { create(:weekly_schedule, course: course, weekday: 0, start_time: "23:59") }
  let!(:tomorrow_schedule) { create(:weekly_schedule, course: course, weekday: 1, start_time: "23:59") }

  before do
    Timecop.travel event_start_at + 1.day
    course.reload
  end
  after { Timecop.return }

  it do
    expect(course.events.count).to eq 1
    PersistPastEvents.new(course).persist!
    expect(course.reload.events.count).to eq 3
  end
end
