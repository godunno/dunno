class Api::V1::CoursesController < Api::V1::ApplicationController
  respond_to :json

  def index
    @courses = current_profile.courses
  end

  def show
    authorize course(current_profile.courses_with_blocked)
    TrackEvent::CourseAccessed.new(@course, current_profile).track
  end

  def create
    @course = Course.new
    course_form = CourseForm.new(@course, course_create_params)
    authorize @course
    course_form.create!
  end

  def update
    authorize course
    course_form = CourseForm.new(course, course_update_params)
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

  def analytics
    authorize course
    @members = students_with_tracking_events(tracking_events(params[:since]))
  end

  def promote_to_moderator
    authorize course
    student.promote_to_moderator_in!(course)
    PromotedToModeratorNotification.new(course, student).deliver
    render nothing: true
  end

  def downgrade_from_moderator
    authorize course
    student.downgrade_from_moderator_in!(course)
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

  def course_update_params
    params
      .require(:course)
      .permit(:name, :start_date, :end_date, :class_name, :institution)
  end

  def course_create_params
    course_update_params
      .merge(teacher: current_profile)
  end

  def student
    Profile.find(params[:course][:student_id])
  end

  def tracking_events(since)
    since ||= 1.day.ago
    course.tracking_events.where(created_at: since..Time.current)
  end

  def students_with_tracking_events(tracking_events)
    @members = course.students.each_with_object({}) do |student, hash|
      hash[student] = tracking_events.where(profile: student)
    end
  end
end
