require 'spec_helper'

describe CreateSchedule do
  let(:start_date) { Date.new(2014, 01, 05) }
  let(:end_date) { Date.new(2014, 01, 13) }
  let(:weekly_schedule_1) do
    stub("WeeklySchedule", weekday: 1, start_time: '14:00', end_time: '16:00')
  end
  let(:weekly_schedule_2) do
    stub("WeeklySchedule", weekday: 3, start_time: '09:00', end_time: '11:00')
  end
  let(:weekly_schedule_3) do
    stub("WeeklySchedule", weekday: 3, start_time: '14:00', end_time: '16:00')
  end
  let(:create_schedule) do
    CreateSchedule.new(
      start_date,
      end_date,
      [weekly_schedule_1, weekly_schedule_2, weekly_schedule_3]
    )
  end

  describe "#schedule_for" do
    it "should create a schedule for a weekly schedule" do
      expect(create_schedule.schedule_for(weekly_schedule_1)).to eq(
        [
          Time.new(2014, 1, 6, 14)..Time.new(2014, 1, 6, 16),
          Time.new(2014, 1, 13, 14)..Time.new(2014, 1, 13, 16)
        ]
      )
    end
  end

  describe "#schedule" do
    subject { create_schedule.schedule }

    it { expect(subject.count).to eq(4) }

    it "should create the time ranges" do
      expect(subject[0]).to eq(
        Time.new(2014, 1, 6, 14)..Time.new(2014, 1, 6, 16)
      )

      expect(subject[1]).to eq(
        Time.new(2014, 1, 8, 9)..Time.new(2014, 1, 8, 11)
      )

      expect(subject[2]).to eq(
        Time.new(2014, 1, 8, 14)..Time.new(2014, 1, 8, 16)
      )

      expect(subject[3]).to eq(
        Time.new(2014, 1, 13, 14)..Time.new(2014, 1, 13, 16)
      )
    end
  end

end
