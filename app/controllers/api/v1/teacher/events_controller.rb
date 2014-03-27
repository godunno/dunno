class Api::V1::Teacher::EventsController < Api::V1::TeacherApplicationController
  respond_to :json

  def open
    event.open!
    render json: "{}", status: 200
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
