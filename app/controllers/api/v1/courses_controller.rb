class Api::V1::CoursesController < Api::V1::ApplicationController
  respond_to :json

  def index
    @courses = current_profile.courses
  end

  def show
    authorize course
    @pagination = EventService.new(course, (params[:month].present? ? Time.zone.parse(params[:month]) : Time.current))
    @events = @pagination.events
  end

  def create
    course_form = Form::CourseForm.new(course_params.merge(teacher: current_profile))
    authorize course_form

    begin
      ActiveRecord::Base.transaction do
        course_form.save!
        CourseScheduler.new(course_form.model).schedule!
      end
    rescue ActiveRecord::RecordInvalid
      render json: { errors: course_form.errors }, status: 400
    else
      render json: { uuid: course_form.model.uuid }
    end
  end

  def update
    authorize course
    course.update(course_params)
    render json: { uuid: course.uuid }
  end

  def destroy
    authorize course
    course.destroy
    render nothing: true
  end

  def register
    @course = course(Course.all)
    authorize @course
    course.add_student current_profile
    TrackerWrapper.new(course.teacher.user).track('Student Joined',
                                                  id: current_user.id,
                                                  name: current_user.name,
                                                  courseName: course.name,
                                                  courseUuid: course.uuid
                                                 )
    render nothing: true
  end

  def unregister
    authorize course
    course.students.destroy(current_profile)
    status = 200
    render nothing: true, status: status
  end

  def students
    authorize course
    @students = course.students
  end

  def search
    @course = course(Course.all)
    authorize @course
  end

  private

  def course(scope = current_profile.courses)
    @course ||= scope.find_by_identifier!(params[:id])
  end

  def course_params
    params.require(:course).permit(:name, :start_date, :end_date, :class_name, :grade, :institution)
  end

  def scheduling
    day = (params[:month] || Date.current).to_time.in_time_zone
    CreateSchedule.new(day.beginning_of_month, day.end_of_month, course.weekly_schedules).schedule
  end

  def serialize_event(event)
    if event.is_a? Event
      {
        start_at: event.start_at,
        end_at: event.end_at,
        order: event.order,
        formatted_status: event.formatted_status(current_profile),
        formatted_classroom: [course.class_name, event.classroom].compact.join(' - '),
      }
    else
      {
        start_at: event.begin,
        end_at: event.end,
        formatted_status: 'draft',
        formatted_classroom: course.class_name,
      }
    end
  end
end
