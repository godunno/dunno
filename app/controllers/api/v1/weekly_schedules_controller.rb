# TODO: Add authorization
class Api::V1::WeeklySchedulesController < ApplicationController
  def transfer
    service = TransferWeeklySchedule.new(from: weekly_schedule, to: create_params)
    if service.valid?
      service.transfer!
      index!
      render json: { affected_events: service.affected_events.count }
    else
      render json: { errors: service.errors }, status: 422
    end
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

  # TODO: Run as a background job
  def index!
    CourseEventsIndexer.index!(weekly_schedule.course)
  end
end
