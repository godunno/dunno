require 'spec_helper'

describe Api::V1::WeeklySchedulesController do
  let(:weekly_schedule) { create(:weekly_schedule) }
  let(:profile) { create(:profile) }

  describe "PATCH /api/v1/weekly_schedules/:uuid/transfer.json" do
    def do_action
      patch "/api/v1/weekly_schedules/#{weekly_schedule.uuid}/transfer", auth_params(profile).merge(weekly_schedule_params).to_json
    end

    let(:weekly_schedule_params) do
      {
        weekly_schedule: {
          weekday: 3,
          start_time: '14:00',
          end_time: '17:00',
          classroom: 'B2'
        }
      }
    end

    it do
      transfer_spy = double("TransferWeeklySchedule", transfer!: nil)
      allow(TransferWeeklySchedule)
      .to receive(:new)
      .with(hash_including(from: weekly_schedule, to: weekly_schedule_params[:weekly_schedule]))
      .and_return(transfer_spy)

      do_action
      expect(transfer_spy).to have_received(:transfer!)
    end
  end

  describe "POST /api/v1/weekly_schedules.json" do
    let(:course) { create(:course) }

    def do_action
      post "/api/v1/weekly_schedules", auth_params(profile).merge(weekly_schedule_params).to_json
    end

    let(:weekly_schedule_params) do
      {
        weekly_schedule: {
          weekday: weekday,
          start_time: start_time,
          end_time: end_time,
          classroom: classroom,
          course_id: course.uuid
        }
      }
    end

    before { do_action }

    context "valid weekly schedule" do
      let(:weekday) { 3 }
      let(:start_time) { '14:00' }
      let(:end_time) { '17:00' }
      let(:classroom) { 'B2' }
      subject { WeeklySchedule.order(:created_at).first }

      it { expect(subject.weekday).to eq weekday }
      it { expect(subject.start_time).to eq start_time }
      it { expect(subject.end_time).to eq end_time }
      it { expect(subject.classroom).to eq classroom }
      it { expect(subject.course).to eq course }
    end

    context "invalid weekly schedule" do
      let(:weekday) { nil }
      let(:start_time) { nil }
      let(:end_time) { nil }
      let(:classroom) { nil }
      it do
        expect(json).to eq(
          "errors" => {
            "weekday" => ["não pode ficar em branco"]
          }
        )
      end
    end
  end

  describe "PATCH /api/v1/weekly_schedules/:uuid.json" do
    let(:weekly_schedule) { create(:weekly_schedule, weekday: 2, start_time: '09:00', end_time: '11:00', classroom: 'A1') }

    def do_action
      patch "/api/v1/weekly_schedules/#{weekly_schedule.uuid}", auth_params(profile).merge(weekly_schedule_params).to_json
    end

    let(:weekly_schedule_params) do
      {
        weekly_schedule: {
          weekday: weekday,
          start_time: start_time,
          end_time: end_time,
          classroom: classroom
        }
      }
    end

    before { do_action }

    context "valid weekly schedule" do
      let(:weekday) { 3 }
      let(:start_time) { '14:00' }
      let(:end_time) { '17:00' }
      let(:classroom) { 'B2' }
      subject { WeeklySchedule.order(:created_at).first }

      it { expect(subject.weekday).to eq weekday }
      it { expect(subject.start_time).to eq start_time }
      it { expect(subject.end_time).to eq end_time }
      it { expect(subject.classroom).to eq classroom }
    end

    context "invalid weekly schedule" do
      let(:weekday) { nil }
      let(:start_time) { nil }
      let(:end_time) { nil }
      let(:classroom) { nil }

      subject { weekly_schedule.reload }

      it do
        expect(json).to eq(
          "errors" => {
            "weekday" => ["não pode ficar em branco"],
            "start_time" => [
              "não pode ficar em branco",
              "invalid time format"
            ],
            "end_time" => [
              "não pode ficar em branco",
              "invalid time format"
            ]
          }
        )
      end

      it { expect(subject.weekday).to eq 2}
      it { expect(subject.start_time).to eq '09:00'}
      it { expect(subject.end_time).to eq '11:00'}
      it { expect(subject.classroom).to eq 'A1'}
    end
  end

  describe "DELETE /api/v1/weekly_schedules/:uuid.json" do
    let(:course) { create(:course) }
    let(:weekly_schedule) { create(:weekly_schedule, course: course) }

    def do_action
      delete "/api/v1/weekly_schedules/#{weekly_schedule.uuid}", auth_params(profile).to_json
    end

    before { do_action }

    context "valid weekly schedule" do
      subject { course.reload }

      it { expect(subject.weekly_schedules).to be_empty }
    end
  end
end
