require 'spec_helper'

describe FindWeeklySchedule do
  let(:course) { create(:course, weekly_schedules: [another_weekly_schedule, weekly_schedule]) }
  let(:weekly_schedule) { create(:weekly_schedule, weekday: 1, start_time: '09:00', end_time: '11:00', classroom: 'A-2', created_at: 1.minute.from_now) }
  let(:another_weekly_schedule) { create(:weekly_schedule, weekday: 2, start_time: '09:00', end_time: '11:00', classroom: 'B-2') }
  let(:start_at) { Time.zone.local(2015, 07, 20, 9) }
  let(:service) { FindWeeklySchedule.new(start_at, course.weekly_schedules.order(:created_at)) }

  it { expect(service.weekly_schedule?).to eq true }
  it { expect(service.end_at).to eq(start_at + 2.hours) }
  it { expect(service.classroom).to eq weekly_schedule.classroom }
end
