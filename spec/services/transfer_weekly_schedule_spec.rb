require 'spec_helper'

# TODO: Updates the weekly schedule instead of creating a new one
describe TransferWeeklySchedule do
  let(:course) { create(:course, end_date: 1.month.from_now) }
  let(:weekly_schedule) { create(:weekly_schedule, weekday: 3, start_time: '09:00', end_time: '11:00', classroom: 'A1', course: course) }
  let(:attributes) { { weekday: weekday, start_time: '14:00', end_time: '17:00', classroom: 'B1' } }
  let(:new_end_at) { new_start_at + 3.hours }
  let(:old_end_at) { old_start_at + 2.hours }
  let!(:event) { create(:event, course: course, start_at: old_start_at, end_at: old_end_at, classroom: weekly_schedule.classroom) }
  let(:service) { TransferWeeklySchedule.new(from: weekly_schedule, to: attributes) }

  def new_weekly_schedule
    WeeklySchedule.order(:created_at).first
  end

  before do
    Timecop.freeze frozen_in_time
    service.transfer!
    [event, weekly_schedule].each(&:reload)
  end

  shared_examples_for "event rescheduling" do
    it { expect(event.start_at).to eq new_start_at }
    it { expect(event.end_at).to eq new_end_at }
    it { expect(event.classroom).to eq attributes[:classroom] }

    describe "weekly schedule" do
      subject { weekly_schedule.reload }

      it { expect(subject.weekday).to eq attributes[:weekday] }
      it { expect(subject.start_time).to eq attributes[:start_time] }
      it { expect(subject.end_time).to eq attributes[:end_time] }
      it { expect(subject.classroom).to eq attributes[:classroom] }
    end
  end

  context "transfering to a later weekday" do
    let(:weekday) { 4 }

    context "with the next occurrence on the same week" do
      let(:frozen_in_time) { Time.zone.parse('2015-08-04 00:00') }
      let(:old_start_at) { Time.zone.parse('2015-08-05 09:00') }
      let(:new_start_at) { Time.zone.parse('2015-08-06 14:00') }

      it_behaves_like "event rescheduling"
    end

    context "with the next occurrence on the next week" do
      let(:frozen_in_time) { Time.zone.parse('2015-08-07 00:00') }
      let(:old_start_at) { Time.zone.parse('2015-08-12 09:00') }
      let(:new_start_at) { Time.zone.parse('2015-08-13 14:00') }

      it_behaves_like "event rescheduling"
    end
  end

  context "transfering to a earlier weekday" do
    let(:weekday) { 2 }

    context "with the next occurrence on the same week" do
      let(:frozen_in_time) { Time.zone.parse('2015-08-03 00:00') }
      let(:old_start_at) { Time.zone.parse('2015-08-05 09:00') }
      let(:new_start_at) { Time.zone.parse('2015-08-04 14:00') }

      it_behaves_like "event rescheduling"
    end

    context "with the next occurrence on the next week" do
      let(:frozen_in_time) { Time.zone.parse('2015-08-07 00:00') }
      let(:old_start_at) { Time.zone.parse('2015-08-12 09:00') }
      let(:new_start_at) { Time.zone.parse('2015-08-11 14:00') }

      it_behaves_like "event rescheduling"
    end
  end
end