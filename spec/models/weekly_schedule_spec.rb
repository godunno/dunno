require 'spec_helper'

describe WeeklySchedule do

  let(:weekly_schedule) { build :weekly_schedule }

  describe "associations" do
    it { is_expected.to belong_to(:course) }
  end

  describe "validations" do

    it { expect(weekly_schedule).to be_valid }

    %w(weekday start_time end_time).each do |attr|
      it { is_expected.to validate_presence_of(attr) }
    end

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
end
