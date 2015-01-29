class Api::V1::Teacher::EventsController < Api::V1::TeacherApplicationController
  respond_to :json

  api :GET, '/api/v1/teacher/events', "Get the teacher's events list."
  def index
    today = Time.zone.now
    @events = current_teacher.events.where(start_at: (today.beginning_of_week..today.end_of_week))
    respond_with @events
  end

  api :GET, '/api/v1/teacher/events/:id', "Get the events's data."
  def show
    respond_with event
  end

  api :POST, '/api/v1/teacher/events', "Create an event."
  def create
    @event_form = Form::EventForm.new(params[:event])
    if @event_form.save
      render nothing: true
    else
      render json: {errors: @event_form.errors}, status: 400
    end
  end

  api :PATCH, '/api/v1/teacher/events/:id', "Update an event."
  def update
    @event_form = Form::EventForm.new(params[:event].merge(uuid: params[:id]))
    @event_form.save
    @event = @event_form.model
    render :show
  end

  api :DELETE, '/api/v1/teacher/events/:id', "Delete the event."
  def destroy
    event.destroy
    render nothing: true
  end

  private

    def event
      @event ||= Event.find_by!(uuid: params[:id])
    end
end
