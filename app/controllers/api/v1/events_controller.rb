class Api::V1::EventsController < Api::V1::ApplicationController
  respond_to :json

  def index
    @events = course.events
    @pagination = MonthsNavigation.new(params[:month])
    @events = EventsForPeriod.new(course, WholePeriod.new(@pagination.current_month).month).events
  end

  def show
    authorize event
    event_navigation = EventNavigation.new(event)
    @previous = event_navigation.previous
    @next = event_navigation.next
    respond_with(event)
  end

  def create
    @event_form = Form::EventForm.new(params[:event])
    authorize @event_form
    if @event_form.save
      render nothing: true
    else
      render json: { errors: @event_form.errors }, status: 400
    end
  end

  def update
    authorize event.course
    EventForm.new(event, update_params).update!
    event.reload
    render :show
  end

  private

  def event
    @event ||= FindOrInitializeEvent.by(course, start_at: params[:start_at])
  end

  def course
    @course ||= current_profile.courses.find_by_identifier!(params[:course_id])
  end

  def update_params
    params.require(:event).permit(:status, topics: [:uuid])
  end
end
