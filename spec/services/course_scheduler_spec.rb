require 'spec_helper'

describe CourseScheduler do

  let(:start_date) { Date.new(2014, 01, 05) }
  let(:end_date) { Date.new(2014, 01, 13) }
  let(:weekly_schedule_1) do
    build(:weekly_schedule, weekday: 1, start_time: '14:00', end_time: '16:00')
  end
  let(:weekly_schedule_2) do
    build(:weekly_schedule, weekday: 3, start_time: '09:00', end_time: '11:00')
  end
  let(:weekly_schedule_3) do
    build(:weekly_schedule, weekday: 3, start_time: '14:00', end_time: '16:00')
  end
  let(:course) do
    create :course,
      start_date: start_date,
      end_date: end_date,
      weekly_schedules: [weekly_schedule_1, weekly_schedule_2, weekly_schedule_3]
  end
  let(:course_scheduler) { CourseScheduler.new(course) }

  it "creates the course's events" do
    course_scheduler.schedule!
    course.reload
    events = course.events.order('start_at asc')

    expect(events[0].start_at).to eq(Time.zone.parse("2014-01-06 14:00"))
    expect(events[0].end_at).to eq(Time.zone.parse("2014-01-06 16:00"))

    expect(events[1].start_at).to eq(Time.zone.parse("2014-01-08 09:00"))
    expect(events[1].end_at).to eq(Time.zone.parse("2014-01-08 11:00"))

    expect(events[2].start_at).to eq(Time.zone.parse("2014-01-08 14:00"))
    expect(events[2].end_at).to eq(Time.zone.parse("2014-01-08 16:00"))

    expect(events[3].start_at).to eq(Time.zone.parse("2014-01-13 14:00"))
    expect(events[3].end_at).to eq(Time.zone.parse("2014-01-13 16:00"))
  end
end
