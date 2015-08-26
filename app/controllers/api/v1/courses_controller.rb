class Api::V1::CoursesController < Api::V1::ApplicationController
  respond_to :json

  def index
    @courses = current_profile.courses
  end

  def show
    authorize course
    @pagination = MonthsNavigation.new(params[:month])
    @events = EventsForPeriod.new(course, WholePeriod.new(@pagination.current_month).month).events
  end

  def create
    course_form = Form::CourseForm.new(course_params)
    authorize course_form
    if course_form.save
      render json: { uuid: course_form.model.uuid }
    else
      render json: { errors: course_form.errors }, status: 400
    end
  end

  def update
    authorize course
    course_form = CourseForm.new(course, course_params)
    course_form.update!
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
    TrackerWrapper.new(course.teacher.user).track(
      'Student Joined',
      id: current_user.id,
      name: current_user.name,
      courseName: course.name,
      courseUuid: course.uuid
    )
    render nothing: true
  rescue Pundit::NotAuthorizedError => exception
    rescue_unauthorized(exception)
  end

  def unregister
    authorize course
    course.students.destroy(current_profile)
    status = 200
    render nothing: true, status: status
  end

  def search
    @course = course(Course.all)
    authorize @course
  rescue Pundit::NotAuthorizedError => exception
    rescue_unauthorized(exception)
  end

  private

  def rescue_unauthorized(exception)
    policy_name = exception.policy.class.to_s.underscore
    render json: {
      errors: {
        unprocessable: t("#{policy_name}.#{exception.query}", scope: "pundit")
      }
    }, status: 422
  end

  def course(scope = current_profile.courses)
    @course ||= scope.find_by_identifier!(params[:id])
  end

  def course_params
    params
      .require(:course)
      .permit(:name, :start_date, :end_date, :class_name, :institution)
      .merge(teacher: current_profile)
  end
end
