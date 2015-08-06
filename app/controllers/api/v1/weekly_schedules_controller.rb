# TODO: Add authorization
class Api::V1::WeeklySchedulesController < ApplicationController
  after_action :index, if: -> { weekly_schedule.try(:valid?) }

  def transfer
    TransferWeeklySchedule.new(from: weekly_schedule, to: create_params).transfer!
    render nothing: true
  end

  def create
    weekly_schedule_form = Form::WeeklyScheduleForm.new(create_params)
    if weekly_schedule_form.save
      @weekly_schedule = weekly_schedule_form.model
    else
      render json: { errors: weekly_schedule_form.errors }, status: 422
    end
  end

  def update
    unless weekly_schedule.update(update_params)
      render json: { errors: weekly_schedule.errors }, status: 422
    end
  end

  def destroy
    weekly_schedule.destroy
    render nothing: true
  end

  private

  def weekly_schedule
    @weekly_schedule ||= WeeklySchedule.find_by(uuid: params[:id])
  end

  def create_params
    params.require(:weekly_schedule).permit(:weekday, :start_time, :end_time, :classroom, :course_id)
  end

  def update_params
    params.require(:weekly_schedule).permit(:weekday, :start_time, :end_time, :classroom)
  end

  # TODO: Run as a background job
  def index
    CourseEventsIndexer.index!(weekly_schedule.course)
  end
end
