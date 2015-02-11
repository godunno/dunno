class Api::V1::Teacher::EventsController < Api::V1::TeacherApplicationController
  respond_to :json

  def index
    today = Time.zone.now
    @events = current_teacher.events.where(start_at: (today.beginning_of_week..today.end_of_week))
    respond_with @events
  end

  def show
    respond_with event
  end

  def create
    @event_form = Form::EventForm.new(params[:event])
    if @event_form.save
      render nothing: true
    else
      render json: {errors: @event_form.errors}, status: 400
    end
  end

  def update
    @event_form = Form::EventForm.new(params[:event].merge(uuid: params[:id]))
    @event_form.save
    @event = @event_form.model.reload
    render :show
  end

  def destroy
    event.destroy
    render nothing: true
  end

  private

    def event
      @event ||= Event.find_by!(uuid: params[:id])
    end
end
