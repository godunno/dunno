require 'spec_helper'

describe Api::V1::WeeklySchedulesController do
  let(:weekly_schedule) { create(:weekly_schedule) }
  let(:profile) { create(:profile) }

  describe "PATCH /api/v1/weekly_schedules/:uuid/transfer" do
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
end
