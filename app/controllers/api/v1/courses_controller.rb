class Api::V1::CoursesController < Api::V1::StudentApplicationController
  respond_to :json

  def index
    @courses = current_student.courses
  end

  def show
    @course = Course.find_by_identifier!(params[:id])
    @pagination = PaginateEventsByMonth.new(@course.events, params[:month])
    @events = @pagination.events
    fresh_when(last_modified: @course.updated_at, etag: [@course, @pagination.current_month])
  end

  def register
    # TODO: test
    course = Course.find_by_identifier!(params[:id])
    begin
      course.add_student current_student
      TrackerWrapper.new(course.teacher.user).track('Student Joined',
                                                    id: current_user.id,
                                                    name: current_user.name,
                                                    course_name: course.name,
                                                    course_uuid: course.uuid
                                                   )
      status = 200
    rescue
      status = 400
    end
    render nothing: true, status: status
  end

  def unregister
    course = Course.find_by_identifier!(params[:id])
    course.students.destroy(current_student)
    status = 200
    render nothing: true, status: status
  end
end
