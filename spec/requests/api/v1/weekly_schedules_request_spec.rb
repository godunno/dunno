require 'spec_helper'

describe Api::V1::WeeklySchedulesController do
  let(:course) { create(:course, teacher: profile) }
  let(:weekly_schedule) { create(:weekly_schedule, course: course) }
  let(:profile) { create(:profile) }

  describe "PATCH /api/v1/weekly_schedules/:uuid/transfer.json" do
    def do_action
      patch "/api/v1/weekly_schedules/#{weekly_schedule.uuid}/transfer", auth_params(profile).merge(weekly_schedule_params).to_json
    end

    context "transfering to a valid weekly schedule" do
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

      let(:affected_events_spy) { double("affected_events", count: 1) }
      let(:transfer_spy) { double("TransferWeeklySchedule", transfer!: nil, affected_events: affected_events_spy, valid?: true) }

      before do
        allow(TransferWeeklySchedule)
        .to receive(:new)
        .with(hash_including(from: weekly_schedule, to: weekly_schedule_params[:weekly_schedule]))
        .and_return(transfer_spy)

        allow(CourseEventsIndexerWorker).to receive(:perform_async)

        do_action
      end

      it { expect(transfer_spy).to have_received(:transfer!) }
      it { expect(transfer_spy).to have_received(:valid?) }
      it { expect(CourseEventsIndexerWorker).to have_received(:perform_async).with(course.id) }
      it { expect(affected_events_spy).to have_received(:count) }
      it { expect(json).to eq("affected_events" => affected_events_spy.count) }
    end

    context "transfering to an invalid weekly schedule" do
      let(:weekly_schedule_params) do
        {
          weekly_schedule: {
            weekday: 2
          }
        }
      end

      let(:errors) { { "weekday" => "invalid" } }
      let(:transfer_spy) { double("TransferWeeklySchedule", valid?: false, errors: errors) }

      before do
        allow(TransferWeeklySchedule)
        .to receive(:new)
        .with(hash_including(from: weekly_schedule, to: weekly_schedule_params[:weekly_schedule]))
        .and_return(transfer_spy)

        do_action
      end

      it { expect(transfer_spy).to have_received(:valid?) }
      it { expect(transfer_spy).to have_received(:errors) }
      it { expect(json).to eq("errors" => errors) }
    end
  end

  describe "POST /api/v1/weekly_schedules.json" do
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

    before do
      allow(CourseEventsIndexerWorker).to receive(:perform_async)
      do_action
    end

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
      it { expect(CourseEventsIndexerWorker).to have_received(:perform_async).with(course.id) }
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
      it { expect(CourseEventsIndexerWorker).not_to have_received(:perform_async).with(course.id) }
    end
  end

  describe "DELETE /api/v1/weekly_schedules/:uuid.json" do
    let(:weekly_schedule) { create(:weekly_schedule, course: course) }

    def do_action
      delete "/api/v1/weekly_schedules/#{weekly_schedule.uuid}", auth_params(profile).to_json
    end

    before do
      allow(CourseEventsIndexerWorker).to receive(:perform_async)
      do_action
    end

    context "valid weekly schedule" do
      subject { course.reload }

      it { expect(subject.weekly_schedules).to be_empty }
      it { expect(CourseEventsIndexerWorker).to have_received(:perform_async).with(course.id) }
    end
  end
end
