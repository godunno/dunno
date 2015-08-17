require 'spec_helper'

describe WeeklySchedule do

  let(:weekly_schedule) { build :weekly_schedule }

  describe "associations" do
    it { is_expected.to belong_to(:course) }
  end

  describe "validations" do

    it { expect(weekly_schedule).to be_valid }

    %w(course weekday start_time end_time).each do |attribute|
      it { is_expected.to validate_presence_of(attribute) }
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

    describe "overlapping in the same course" do
      let!(:course) { create(:course) }
      let!(:weekly_schedule) { create(:weekly_schedule, course: course, weekday: 1, start_time: '09:00', end_time: '11:00') }
      subject { build(:weekly_schedule, course: course, weekday: 1, start_time: start_time, end_time: end_time) }

      before do
        course.reload
      end

      context "starting before" do
        let(:start_time) { '08:00' }
        let(:end_time) { '09:30' }

        it { is_expected.not_to be_valid }
      end

      context "finishing later" do
        let(:start_time) { '09:30' }
        let(:end_time) { '11:30' }

        it { is_expected.not_to be_valid }
      end

      context "contained in another weekly schedule" do
        let(:start_time) { '09:30' }
        let(:end_time) { '10:30' }

        it { is_expected.not_to be_valid }
      end

      context "contains another weekly schedule" do
        let(:start_time) { '08:30' }
        let(:end_time) { '11:30' }

        it { is_expected.not_to be_valid }
      end

      context "finishing right before" do
        let(:start_time) { '08:30' }
        let(:end_time) { '09:00' }

        it { is_expected.to be_valid }
      end

      context "starting right after" do
        let(:start_time) { '11:00' }
        let(:end_time) { '11:30' }

        it { is_expected.to be_valid }
      end

      context "updating existing weekly schedule" do
        let(:start_time) { '08:00' }
        let(:end_time) { '09:30' }

        before do
          weekly_schedule.start_time = start_time
          weekly_schedule.end_time = end_time
        end

        subject { weekly_schedule }

        it { is_expected.to be_valid }
      end
    end
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
    let(:weekly_schedule) { create(:weekly_schedule, start_time: '09:00', end_time: '11:00', course: course) }
    subject { weekly_schedule.reload.to_recurrence_rule.to_s }

    context "with course's end date" do
      let!(:course) { create(:course, end_date: Date.parse('2015-07-31')) }

      it { is_expected.to eq "Weekly on Mondays on the 9th hour of the day on the 0th minute of the hour on the 0th second of the minute until July 31, 2015" }
    end

    context "without course's end date" do
      let!(:course) { create(:course, end_date: nil) }

      it { is_expected.to eq "Weekly on Mondays on the 9th hour of the day on the 0th minute of the hour on the 0th second of the minute" }
    end
  end
end
