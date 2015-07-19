class Api::V1::EventsController < Api::V1::ApplicationController
  respond_to :json

  def index
    today = Time.current
    @events = if params[:course_id]
                search_parameters = params.slice(:page, :per_page, :offset, :until)
                SearchEventsByCourse.search(current_profile.courses.find_by_identifier!(params[:course_id]), search_parameters).records.to_a
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
    @event ||= course.events.find_by(start_at: date.beginning_of_day..date.end_of_day) || build_event
  end

  def date
    params[:start_at].to_date
  end

  # TODO: Extract to service
  def build_event
    weekday = params[:start_at].to_date.wday
    weekly_schedule = course.weekly_schedules.detect { |w| w.weekday == weekday }

    # TODO: Reuse the code from CreateSchedule service
    start_time = TimeOfDay.parse(weekly_schedule.start_time)
    end_time = TimeOfDay.parse(weekly_schedule.end_time)
    start_at = date.in_time_zone.change(
      hour: start_time.hour,
      min:  start_time.minute
    )
    end_at = date.in_time_zone.change(
      hour: end_time.hour,
      min:  end_time.minute
    )
    Event.new(
      course: course,
      classroom: weekly_schedule.classroom,
      start_at: start_at,
      end_at: end_at
    )
  end

  def course
    @course ||= current_profile.courses.find_by_identifier!(params[:course_id])
  end

  def update_params
    params.require(:event).permit(:status, topics: [:uuid])
  end
end
