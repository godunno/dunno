class Api::V1::EventsController < Api::V1::ApplicationController
  respond_to :json

  def index
    @events = if params[:course_id]
                search_parameters = params.slice(:page, :per_page, :offset, :until)
                SearchEventsByCourse.search(current_profile.courses.find_by_identifier!(params[:course_id]), search_parameters).records.to_a
              else
                current_profile.events.where(start_at: WholePeriod.new(Time.current).week)
              end
    respond_with(@events)
  end

  def show
    authorize event
    event_navigation = EventNavigation.new(event)
    @previous = event_navigation.previous
    @next = event_navigation.next
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
    @event ||= FindOrInitializeEvent.new(course).by({ start_at: params[:start_at] }, nil)
  end

  def course
    @course ||= current_profile.courses.find_by_identifier!(params[:course_id])
  end

  def update_params
    params.require(:event).permit(:status, topics: [:uuid])
  end
end
