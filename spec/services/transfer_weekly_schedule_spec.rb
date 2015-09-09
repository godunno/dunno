require 'spec_helper'

describe TransferWeeklySchedule do
  let(:course) { create(:course, end_date: 1.month.from_now) }
  let(:weekly_schedule) { create(:weekly_schedule, weekday: 3, start_time: '09:00', end_time: '11:00', classroom: 'A1', course: course) }
  let(:attributes) { { weekday: weekday, start_time: '14:00', end_time: '17:00', classroom: 'B1' } }
  let(:new_end_at) { new_start_at + 3.hours }
  let(:old_end_at) { old_start_at + 2.hours }
  let(:affected_event) { create(:event, course: course, start_at: old_start_at, end_at: old_end_at, classroom: weekly_schedule.classroom) }
  let(:non_affected_event) { create(:event, course: course, start_at: old_start_at + 1.day, end_at: old_end_at + 1.day) }
  let(:service) { TransferWeeklySchedule.new(from: weekly_schedule, to: attributes) }

  def new_weekly_schedule
    WeeklySchedule.order(:created_at).first
  end

  describe "#valid?" do
    context "with valid attributes in the :to param" do
      let(:weekday) { 1 }

      it { expect(service).to be_valid }
    end

    context "overlapping with itself" do
      let(:attributes) { { end_time: '12:00' } }

      it { expect(service).to be_valid }
    end

    context "with invalid attributes in the :to param" do
      let(:attributes) { { start_time: '' } }

      it do
        expect(service).not_to be_valid
        expect(service.errors.keys).to eq([:start_time])
        expect { service.transfer! }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  shared_examples_for "event rescheduling" do
    before do
      Timecop.freeze frozen_in_time

      affected_event.save!
      non_affected_event.save!

      service.transfer!
      [affected_event, non_affected_event, weekly_schedule].each(&:reload)
    end

    after { Timecop.return }

    it { expect(affected_event.start_at).to eq new_start_at }
    it { expect(affected_event.end_at).to eq new_end_at }
    it { expect(affected_event.classroom).to eq attributes[:classroom] }

    it { expect(non_affected_event.start_at).to eq old_start_at + 1.day }
    it { expect(non_affected_event.end_at).to eq old_end_at + 1.day }

    it { expect(service.affected_events).to eq [affected_event] }

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

    context "with the next occurrence in the same day" do
      let(:frozen_in_time) { Time.zone.parse('2015-08-05 08:00') }
      let(:old_start_at) { Time.zone.parse('2015-08-05 09:00') }
      let(:new_start_at) { Time.zone.parse('2015-08-06 14:00') }

      it_behaves_like "event rescheduling"
    end

    context "with next occurrence of old schedule on the next week but next occurrence of new schedule on the same week" do
      let(:frozen_in_time) { Time.zone.parse('2015-08-06 00:00') }
      let(:old_start_at) { Time.zone.parse('2015-08-12 09:00') }
      let(:new_start_at) { Time.zone.parse('2015-08-13 14:00') }
      let(:affected_event) { create(:event, course: course, start_at: old_start_at, end_at: old_end_at, classroom: weekly_schedule.classroom) }
      let(:non_affected_event) { create(:event, course: course, start_at: frozen_in_time - 2.hours, end_at: frozen_in_time - 1.hour) }

      before do
        Timecop.freeze frozen_in_time

        affected_event.save!
        non_affected_event.save!

        service.transfer!
        [affected_event, non_affected_event, weekly_schedule].each(&:reload)
      end

      after { Timecop.return }

      it { expect(affected_event.start_at).to eq new_start_at }
      it { expect(affected_event.end_at).to eq new_end_at }

      it { expect(non_affected_event.start_at).to eq frozen_in_time - 2.hours }
      it { expect(non_affected_event.end_at).to eq frozen_in_time - 1.hour }
    end

    context "with an occurrence which already happened in the same day" do
      let(:frozen_in_time) { Time.zone.parse('2015-08-05 12:00') }
      let(:old_start_at) { Time.zone.parse('2015-08-12 09:00') }
      let(:new_start_at) { Time.zone.parse('2015-08-13 14:00') }
      let(:affected_event) { create(:event, course: course, start_at: old_start_at, end_at: old_end_at, classroom: weekly_schedule.classroom) }
      let(:non_affected_event) { create(:event, course: course, start_at: old_start_at - 1.week, end_at: old_start_at - 1.week + 2.hours) }

      before do
        Timecop.freeze frozen_in_time

        affected_event.save!
        non_affected_event.save!

        service.transfer!
        [affected_event, non_affected_event, weekly_schedule].each(&:reload)
      end

      after { Timecop.return }

      it { expect(affected_event.start_at).to eq new_start_at }
      it { expect(affected_event.end_at).to eq new_end_at }

      it { expect(non_affected_event.start_at).to eq(old_start_at - 1.week) }
      it { expect(non_affected_event.end_at).to eq(old_start_at - 1.week + 2.hours) }
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

  context "when its course doesn't have an end_date" do
    let(:course) { create(:course, start_date: Date.parse('2015-08-01'), end_date: nil) }
    let(:weekday) { weekly_schedule.weekday }

    before { Timecop.freeze Time.zone.parse('2015-08-06 00:00') }

    after { Timecop.return }

    it "and there's no events" do
      expect { service.transfer! }.not_to raise_error
    end

    it "and there's a past event" do
      start_at = Time.zone.parse('2015-08-05 09:00')
      event = create(:event, course: course, start_at: start_at)
      expect { service.transfer! }
        .not_to change { event.reload.start_at }
    end

    it "and there's a future event" do
      start_at = Time.zone.parse('2015-08-12 09:00')
      event = create(:event, course: course, start_at: start_at)
      expect { service.transfer! }
        .to change { event.reload.start_at }
        .from(start_at)
        .to(start_at.change(hour: 14))
    end
  end

  describe "finds event regardless the milliseconds on the start_at" do
    let(:course) { create(:course, start_date: Date.parse('2015-08-01'), end_date: nil) }
    let(:weekday) { weekly_schedule.weekday }
    let(:milliseconds) { 12345 }

    before { Timecop.freeze Time.zone.parse('2015-08-06 00:00') }

    after { Timecop.return }

    it do
      start_at = Time.zone.local(2015, 8, 12, 9, 0, 0, milliseconds)
      event = create(:event, course: course, start_at: start_at)
      expect { service.transfer! }
        .to change { event.reload.start_at }
        .from(start_at)
        .to(start_at.change(hour: 14, usec: milliseconds))
    end
  end
end
