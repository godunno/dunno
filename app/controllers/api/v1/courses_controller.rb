class Api::V1::CoursesController < Api::V1::StudentApplicationController
  respond_to :json

  def index
    @courses = current_student.courses
  end

  def show
    @course = Course.find_by!(uuid: params[:id])
    @pagination = PaginateEventsByMonth.new(@course.events, params[:month])
    @events = @pagination.events
    fresh_when(last_modified: @course.updated_at, etag: [@course, params[:month]])
  end

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
