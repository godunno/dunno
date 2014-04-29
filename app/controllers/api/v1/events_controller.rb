class Api::V1::EventsController < Api::V1::StudentApplicationController
  respond_to :json

  def index
    @events = current_student.events
    respond_with(@events)
  end

  def attend
    if event.opened?
      respond_with @event
    else
      return render json: { errors: I18n.t('errors.event.closed') }, status: 403
    end
      Attendance.create!(event: event, student: current_student)
  end

  def timeline
    respond_with event
  end

  def validate_attendance
    if Beacon.where(params[:beacon]).first == event.beacon
      attendance = Attendance.where(event: event, student: current_student).first!
      attendance.update(validated: true)
      render nothing: true, status: 200
    else
      render nothing: true, status: 400
    end
  end

  private
    def event
      @event ||= Event.where(uuid: params[:id]).first!
    end
end
