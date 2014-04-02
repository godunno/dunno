class Api::V1::Teacher::EventsController < Api::V1::TeacherApplicationController
  respond_to :json

  def open
    if event.opened?
      render nothing: true, status: 304
    else
      event.open!
      respond_with event
    end
  end

  def close
    event.close!
    EventPusher.new(event).close
    render json: "{}", status: 200
  end

  private

    def event
      @event ||= Event.where(uuid: params[:id]).first
    end
end
