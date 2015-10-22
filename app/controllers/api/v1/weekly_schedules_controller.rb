class Api::V1::WeeklySchedulesController < Api::V1::ApplicationController
  def transfer
    authorize weekly_schedule
    service = TransferWeeklySchedule.new(from: weekly_schedule, to: create_params)
    if service.valid?
      service.transfer!
      index!
      render json: { affected_events: service.affected_events.count }
    else
      render json: { errors: service.errors.details }, status: 422
    end
  end

  def create
    weekly_schedule_form = Form::WeeklyScheduleForm.new(create_params)
    authorize weekly_schedule_form
    if weekly_schedule_form.save
      @weekly_schedule = weekly_schedule_form.model
      index!
    else
      render json: { errors: weekly_schedule_form.errors.details }, status: 422
    end
  end

  def destroy
    authorize weekly_schedule
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

  def index!
    CourseEventsIndexerWorker.perform_async(weekly_schedule.course_id)
  end
end
