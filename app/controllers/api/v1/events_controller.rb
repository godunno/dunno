class Api::V1::EventsController < Api::V1::ApplicationController
  respond_to :json

  def index
    today = Time.current
    @events = current_profile.events.where(start_at: (today.beginning_of_week..today.end_of_week))
    respond_with(@events)
  end

  def show
    respond_with(event)
  end

  # TODO: Add authorization
  def create
    @event_form = Form::EventForm.new(params[:event])
    if @event_form.save
      render nothing: true
    else
      render json: { errors: @event_form.errors }, status: 400
    end
  end

  # TODO: Add authorization
  def update
    EventForm.new(event, update_params).update!
    event.reload
    render :show
  end

  private

  def event
    @event ||= current_profile.events.find_by!(uuid: params[:id])
  end

  def update_params
    params.require(:event).permit(:status, topics: [:uuid])
  end
end
