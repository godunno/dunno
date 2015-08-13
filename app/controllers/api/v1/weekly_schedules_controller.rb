# TODO: Add authorization
class Api::V1::WeeklySchedulesController < ApplicationController
  def transfer
    service = TransferWeeklySchedule.new(from: weekly_schedule, to: create_params)
    service.transfer!
    index!
    render json: { affected_events: service.affected_events.count }
  end

  def create
    weekly_schedule_form = Form::WeeklyScheduleForm.new(create_params)
    if weekly_schedule_form.save
      @weekly_schedule = weekly_schedule_form.model
      index!
    else
      render json: { errors: weekly_schedule_form.errors }, status: 422
    end
  end

  def update
    if weekly_schedule.update(update_params)
      render :create
      index!
    else
      render json: { errors: weekly_schedule.errors }, status: 422
    end
  end

  def destroy
    weekly_schedule.destroy
    index!
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
  def index!
    CourseEventsIndexer.index!(weekly_schedule.course)
  end
end
