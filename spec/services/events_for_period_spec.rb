require 'spec_helper'

describe EventsForPeriod do
  let(:weekly_schedule) { create(:weekly_schedule, weekday: 2, start_time: '21:00', end_time: '23:00') }
  let(:course) { create(:course, weekly_schedules: [weekly_schedule], start_date: 7.days.ago, end_date: 7.days.from_now) }
  let(:service) { EventsForPeriod.new(course, WholePeriod.new(Date.current).month) }

  let(:events_start_at) { service.events.map { |event| event.start_at.change(usec: 0) } }

  before { Timecop.travel Time.zone.parse("2015-08-25 10:00")  }
  after { Timecop.return }

  it "finds persisted events in the past" do
    event = create(:event, course: course, start_at: Date.yesterday.change(usec: 0))
    expect(events_start_at).to include event.start_at
  end

  it "doesnt find non-persisted events in the past" do
    event = CourseScheduler.new(course, 7.days.ago..Date.current).events.first
    expect(events_start_at).to_not include event.start_at
  end

  it "finds non-persisted in the future" do
    event = CourseScheduler.new(course, Date.current..7.days.from_now).events.first
    expect(events_start_at).to include event.start_at
  end

  it "finds persisted in the future" do
    event = create(:event, course: course, start_at: 1.day.from_now.change(usec: 0))
    expect(events_start_at).to include event.start_at
  end

  it "merges both past and future events" do
    event_at_tomorrow = create(:event, course: course, start_at: 1.day.from_now)
    event_at_today = CourseScheduler.new(course, Date.current..7.days.from_now).events.first
    event_at_yesterday = create(:event, course: course, start_at: Date.yesterday)

    expect(events_start_at).to eq [
      event_at_yesterday.start_at,
      event_at_today.start_at,
      event_at_tomorrow.start_at.change(usec: 0)
    ]
  end
end
