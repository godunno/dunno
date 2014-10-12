class Api::V1::Teacher::CoursesController < Api::V1::TeacherApplicationController
  respond_to :json

  api :GET, '/api/v1/teacher/courses', "Get the teacher's courses list."
  def index
    @courses = current_teacher.courses.includes(:weekly_schedules)
    respond_with @courses #.to_json(root: false)
  end

  api :GET, '/api/v1/teacher/courses/:id', "Get the course's data."
  def show
    if course
      respond_with course
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
    course_form = Form::CourseForm.new(params[:course].merge(teacher: current_teacher))

    begin
      ActiveRecord::Base.transaction do
        course_form.save!
        CourseScheduler.new(course_form.model).schedule!
      end
    rescue ActiveRecord::RecordInvalid
      render json: {errors: course_form.errors}, status: 400
    else
      render json: {uuid: course_form.model.uuid}
    end
  end

  api :PATCH, '/api/v1/teacher/courses/:id', "Update a course."
  def update
    course.update(course_params)
    render json: {uuid: course.uuid}
  end

  api :GET, '/api/v1/teacher/courses/:id/students', "Get the course's students list."
  def students
    @students = course.students
  end

  private

    def course
      @course ||= current_teacher.courses
        .where(uuid: params[:id]).first
    end

    def course_params
      params.require(:course).
        permit(:name,
               :organization_id,
               :class_name,
               :grade,
               :institution)
    end
end
