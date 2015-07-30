require 'spec_helper'

describe WeeklySchedule do

  let(:weekly_schedule) { build :weekly_schedule }

  describe "associations" do
    it { is_expected.to belong_to(:course) }
  end

  describe "validations" do

    it { expect(weekly_schedule).to be_valid }

    it { is_expected.to validate_presence_of(:weekday) }

    it "should validate time format" do
      %w(start_time end_time).each do |time|
        weekly_schedule[time] = "9"
        expect(weekly_schedule).not_to be_valid

        weekly_schedule[time] = "9:00"
        expect(weekly_schedule).not_to be_valid

        weekly_schedule[time] = "24:00"
        expect(weekly_schedule).not_to be_valid

        weekly_schedule[time] = "09:60"
        expect(weekly_schedule).not_to be_valid

        weekly_schedule[time] = "09:00"
        expect(weekly_schedule).to be_valid
      end
    end
  end

  describe "#complete" do
    let!(:complete_weekly_schedule) { create :weekly_schedule }
    let!(:semicomplete_weekly_schedule) { create :weekly_schedule, start_time: nil }
    let!(:incomplete_weekly_schedule) { create :weekly_schedule, start_time: nil, end_time: nil }
    it { expect(WeeklySchedule.complete).to eq([complete_weekly_schedule]) }
  end

  describe "default order" do
    let(:monday) { create(:weekly_schedule, weekday: 0) }
    let(:tuesday) { create(:weekly_schedule, weekday: 1) }
    let(:wednesday) { create(:weekly_schedule, weekday: 2) }

    before do
      tuesday.save!
      wednesday.save!
      monday.save!
    end

    it { expect(WeeklySchedule.all).to eq([monday, tuesday, wednesday]) }
  end

  describe "#to_recurrence_rule" do
    let(:weekly_schedule) { create(:weekly_schedule, start_time: '09:00', end_time: '11:00') }
    subject { weekly_schedule.reload.to_recurrence_rule.to_s }

    context "with course's end date" do
      let!(:course) { create(:course, end_date: Date.parse('2015-07-31'), weekly_schedules: [weekly_schedule]) }

      it { is_expected.to eq "Weekly on Mondays on the 9th hour of the day on the 0th minute of the hour on the 0th second of the minute until July 31, 2015" }
    end

    context "without course's end date" do
      it { is_expected.to eq "Weekly on Mondays on the 9th hour of the day on the 0th minute of the hour on the 0th second of the minute" }
    end
  end
end
