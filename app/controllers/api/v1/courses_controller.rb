class Api::V1::CoursesController < Api::V1::StudentApplicationController
  respond_to :json

  def index
    @courses = current_student.courses
    respond_with(@courses)
  end
end
