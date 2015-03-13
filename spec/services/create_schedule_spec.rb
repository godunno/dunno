require 'spec_helper'

describe CreateSchedule do
  let(:start_date) { Date.new(2014, 01, 05) }
  let(:end_date) { Date.new(2014, 01, 13) }
  let(:weekly_schedule_1) do
    double("WeeklySchedule", weekday: 1, start_time: '14:00', end_time: '16:00', classroom: '201-A')
  end
  let(:weekly_schedule_2) do
    double("WeeklySchedule", weekday: 3, start_time: '09:00', end_time: '11:00', classroom: '201-B')
  end
  let(:weekly_schedule_3) do
    double("WeeklySchedule", weekday: 3, start_time: '14:00', end_time: '16:00', classroom: '201-C')
  end
  let(:create_schedule) do
    CreateSchedule.new(
      start_date,
      end_date,
      [weekly_schedule_1, weekly_schedule_2, weekly_schedule_3]
    )
  end

  describe "#schedule" do
    subject { create_schedule.schedule }

    it { expect(subject.count).to eq(4) }

    it { expect(subject[0].begin).to eq(Time.zone.parse("2014-01-06 14:00")) }
    it { expect(subject[0].end).to eq(Time.zone.parse("2014-01-06 16:00")) }
    it { expect(subject[0].classroom).to eq('201-A') }

    it { expect(subject[1].begin).to eq(Time.zone.parse("2014-01-08 09:00")) }
    it { expect(subject[1].end).to eq(Time.zone.parse("2014-01-08 11:00")) }
    it { expect(subject[1].classroom).to eq('201-B') }

    it { expect(subject[2].begin).to eq(Time.zone.parse("2014-01-08 14:00")) }
    it { expect(subject[2].end).to eq(Time.zone.parse("2014-01-08 16:00")) }
    it { expect(subject[2].classroom).to eq('201-C') }

    it { expect(subject[3].begin).to eq(Time.zone.parse("2014-01-13 14:00")) }
    it { expect(subject[3].end).to eq(Time.zone.parse("2014-01-13 16:00")) }
    it { expect(subject[3].classroom).to eq('201-A') }
  end
end
