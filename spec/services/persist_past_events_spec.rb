require 'spec_helper'

describe PersistPastEvents do
  let(:course) { create(:course, start_date: Date.yesterday, end_date: 1.month.from_now) }
  let(:event_start_at) { Time.zone.parse('2015-08-01 09:00') }
  let(:event) { build(:event, course: course, start_at: event_start_at) }

  before do
    Timecop.travel event_start_at
    (0..6).each do |weekday|
      create(:weekly_schedule, course: course, weekday: weekday, start_time: '09:00')
    end
    event.save!
    course.reload
  end
  after { Timecop.return }

  it do
    expect(course.events.count).to eq 1
    PersistPastEvents.new(course).persist!
    expect(course.reload.events.count).to eq 3
  end
end
