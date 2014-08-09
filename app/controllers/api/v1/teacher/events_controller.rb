class Api::V1::Teacher::EventsController < Api::V1::TeacherApplicationController
  respond_to :json

  api :GET, '/api/v1/teacher/events', "Get the teacher's events list."
  def index
    # TODO: get only the teacher's events
    @events = current_teacher.events.limit(9)
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
    render nothing: true
  end

  api :DELETE, '/api/v1/teacher/events/:id', "Delete the event."
  def destroy
    event.destroy
    render nothing: true
  end

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
