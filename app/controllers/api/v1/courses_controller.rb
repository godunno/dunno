class Api::V1::CoursesController < Api::V1::StudentApplicationController
  respond_to :json

  api :GET, '/api/v1/courses', "Get the student's courses, along with it's events."
  def index
    @courses = current_student.courses
    respond_with(@courses)
  end

  api :GET, '/api/v1/courses/:identifier', "Get the course's information using its uuid or access_code"
  def show
    @course = Course.find_by_identifier(params[:id])
    if @course
      respond_with(@course)
    else
      render nothing: true, status: 404
    end
  end

  api :POST, '/api/v1/courses/:uuid/register', "Register the student to the course"
  def register
    # TODO: test
    course = Course.find_by_identifier(params[:id])
    if course
      begin
        course.students << current_student
        status = 200
      rescue
        status = 400
      end
    else
      status = 404
    end
    render nothing: true, status: status
  end

  api :DELETE, '/api/v1/courses/:uuid/unregister', "Unregister the student from the course"
  def unregister
    course = Course.find_by_identifier(params[:id])
    if course
      course.students.destroy(current_student)
      status = 200
    else
      status = 404
    end
    render nothing: true, status: status
  end
end
