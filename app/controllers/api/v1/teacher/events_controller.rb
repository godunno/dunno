class Api::V1::Teacher::EventsController < Api::V1::TeacherApplicationController
  respond_to :json

  api :PATCH, '/api/v1/teacher/events/:id/open', "Opens the event so students can attend to it."
  def open
    if event.opened?
      render nothing: true, status: 304
    else
      event.open!
      CoursePusher.new(event).open
      respond_with event
    end
  end

  api :PATCH, '/api/v1/teacher/events/:id/close', "Closes the event and releases the thermometers."
  def close
    if event.closed?
      render nothing: true, status: 304
    else
      event.close!
      EventPusher.new(event).close
      render json: "{}", status: 200
    end
  end

  private

    def event
      @event ||= Event.where(uuid: params[:id]).first
    end
end
