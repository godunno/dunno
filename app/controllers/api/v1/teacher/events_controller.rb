class Api::V1::Teacher::EventsController < Api::V1::TeacherApplicationController
  respond_to :json

  def index
    respond_with Event.all
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
    render nothing: true
  end

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
