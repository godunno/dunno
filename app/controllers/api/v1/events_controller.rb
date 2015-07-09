class Api::V1::EventsController < Api::V1::ApplicationController
  respond_to :json

  def index
    today = Time.current
    @events = if params[:course_id]
                current_profile.courses.find_by_identifier!(params[:course_id]).events
              else
                current_profile.events.where(start_at: (today.beginning_of_week..today.end_of_week))
              end
    respond_with(@events)
  end

  def show
    authorize event
    respond_with(event)
  end

  # TODO: Add authorization
  def create
    @event_form = Form::EventForm.new(params[:event])
    authorize @event_form
    if @event_form.save
      render nothing: true
    else
      render json: { errors: @event_form.errors }, status: 400
    end
  end

  # TODO: Add authorization
  def update
    authorize event.course
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
