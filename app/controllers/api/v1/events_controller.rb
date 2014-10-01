class Api::V1::EventsController < Api::V1::StudentApplicationController
  respond_to :json

  api :GET, '/api/v1/events', "Get the student's events list."
  def index
    @events = current_student.events
    respond_with(@events)
  end

  api :GET, '/api/v1/events/:id/attend', "Get the event's data if it's opened and creates an Attendance."
  def attend
    if event.opened?
      respond_with @event
    else
      return render json: { errors: I18n.t('errors.event.closed') }, status: 403
    end
      Attendance.create!(event: event, student: current_student)
  end

  api :GET, '/api/v1/events/:id/timeline', "Get the event's data."
  def timeline
    respond_with event
  end

  api :PATCH, '/api/v1/events/:id/validate_attendance', "Validates that the student has attended the event."
  def validate_attendance
    if Beacon.where(beacon_params).first == event.beacon
      attendance = Attendance.where(event: event, student: current_student).first!
      attendance.update(validated: true)
      render nothing: true, status: 200
    else
      render nothing: true, status: 400
    end
  end

  private

  def beacon_params
    params.require(:beacon).permit(:uuid, :minor, :major, :title)
  end

  def event
    @event ||= Event.where(uuid: params[:id]).first!
  end
end
