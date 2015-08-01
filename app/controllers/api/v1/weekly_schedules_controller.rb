class Api::V1::WeeklySchedulesController < ApplicationController
  def transfer
    TransferWeeklySchedule.new(from: weekly_schedule, to: weekly_schedule_params).transfer!
    render nothing: true
  end

  private

  def weekly_schedule
    @weekly_schedule ||= WeeklySchedule.find_by(uuid: params[:id])
  end

  def new_weekly_schedule
    @new_weekly_schedule ||= WeeklySchedule.new(weekly_schedule_params)
  end

  def weekly_schedule_params
    params.require(:weekly_schedule).permit(:weekday, :start_time, :end_time, :classroom)
  end
end
