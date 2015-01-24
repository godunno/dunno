class Api::V1::EventsController < Api::V1::StudentApplicationController
  respond_to :json

  def index
    @events = current_student.events
    respond_with(@events)
  end

  def show
    respond_with(event)
  end

  private

  def event
    @event ||= Event.find_by!(uuid: params[:id])
  end
end
