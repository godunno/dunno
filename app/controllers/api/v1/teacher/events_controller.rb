class Api::V1::Teacher::EventsController < Api::V1::TeacherApplicationController
  respond_to :json

  def index
    today = Time.current
    @events = current_teacher.events.where(start_at: (today.beginning_of_week..today.end_of_week))
    respond_with @events
  end

  def show
    respond_with event
  end

  # TODO: Use strong parameters
  def create
    @event_form = Form::EventForm.new(params[:event])
    if @event_form.save
      render nothing: true
    else
      render json: {errors: @event_form.errors}, status: 400
    end
  end

  def update
    EventForm.new(event, update_params).update!
    event.reload
    render :show
  end

  private

  def update_params
    params.require(:event).permit(:status, topics: [:uuid])
  end

  def event
    @event ||= current_teacher.events.find_by!(uuid: params[:id])
  end
end
