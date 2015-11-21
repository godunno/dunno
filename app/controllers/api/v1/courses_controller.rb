class Api::V1::CoursesController < Api::V1::ApplicationController
  respond_to :json

  def index
    @courses = current_profile.courses
  end

  def show
    authorize course(current_profile.courses_with_blocked)
  end

  def create
    @course = Course.new
    course_form = CourseForm.new(@course, course_params)
    authorize @course
    course_form.create!
  end

  def update
    authorize course
    course_form = CourseForm.new(course, course_params)
    if course_form.update!
      render :create
    else
      render json: { errors: course_form.errors }, status: 400
    end
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
    track_student_joining_course
    NewMemberNotification.new(course, current_profile).deliver
    render :create
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

  def block
    authorize course
    student.block_in!(course)
    BlockedNotification.new(course, student).deliver
    render nothing: true
  end

  def unblock
    authorize course
    student.unblock_in!(course)
    render nothing: true
  end

  private

  def track_student_joining_course
    TrackerWrapper.new(course.teacher.user).track(
      'Student Joined',
      id: current_user.id,
      name: current_user.name,
      courseName: course.name,
      courseUuid: course.uuid
    )
  end

  def rescue_unauthorized(exception)
    policy_name = exception.policy.class.to_s.underscore
    error = current_profile.blocked_in?(@course) ? 'blocked' : 'already_registered'
    render json: {
      errors: {
        unprocessable: t("#{policy_name}.#{exception.query}.#{error}", scope: "pundit")
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

  def student
    Profile.find(params[:course][:student_id])
  end
end
