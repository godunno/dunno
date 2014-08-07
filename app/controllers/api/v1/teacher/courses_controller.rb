class Api::V1::Teacher::CoursesController < Api::V1::TeacherApplicationController
  respond_to :json

  api :GET, '/api/v1/teacher/courses', "Get the teacher's courses list."
  def index
    @courses = current_teacher.courses
    respond_with @courses.to_json(root: false)
  end

  api :GET, '/api/v1/teacher/courses/:id', "Get the course's data."
  def show
    if course
      respond_with course.to_json(include: :events)
    else
      render nothing: true, status: 404
    end
  end

  api :DELETE, '/api/v1/teacher/courses/:id', "Delete the course."
  def destroy
    course.destroy
    render nothing: true
  end

  api :POST, '/api/v1/teacher/courses', "Create a course and schedule its events."
  def create
    @course = Course.new(course_params)
    @course.teacher = current_teacher

    begin
      ActiveRecord::Base.transaction do
        @course.save!
        CourseScheduler.new(@course).schedule!
      end
    rescue ActiveRecord::RecordInvalid
      render json: {errors: @course.errors}, status: 400
    else
      render nothing: true
    end
  end

  api :PATCH, '/api/v1/teacher/courses/:id', "Update a course."
  def update
    course.update(course_params)
    render nothing: true
  end

  private

  def course
    @course ||= current_teacher.courses.
      where(uuid: params[:id]).first
  end

  def course_params
    params.require(:course).
      permit(:name,
             :organization_id,
             :start_date,
             :end_date,
             :classroom)
  end
end
