class Api::V1::CoursesController < Api::V1::StudentApplicationController
  respond_to :json

  api :GET, '/api/v1/courses', "Get the student's courses, along with it's events."
  def index
    @courses = current_student.courses
    respond_with(@courses)
  end
end
