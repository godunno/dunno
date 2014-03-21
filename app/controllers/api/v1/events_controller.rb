class Api::V1::EventsController < Api::V1::StudentApplicationController
  respond_to :json

  def index
    @events = current_student.events
    respond_with @events, root: false
  end

  def attend
    if event.opened?
      respond_with @event
    else
      render nothing: true, status: 403
    end
  end

  def timeline
    respond_with event
  end

  private
    def event
      @event ||= Event.where(uuid: params[:id]).first!
    end
end
