class Api::V1::CoursesController < Api::V1::ApplicationController
  respond_to :json

  def index
    @courses = current_profile.courses
  end

  def show
    @pagination = PaginateEventsByMonth.new(course.events, params[:month])
    @events = @pagination.events
  end

  def create
    course_form = Form::CourseForm.new(course_params.merge(teacher: current_profile))

    begin
      ActiveRecord::Base.transaction do
        course_form.save!
        CourseScheduler.new(course_form.model).schedule!
      end
    rescue ActiveRecord::RecordInvalid
      render json: { errors: course_form.errors }, status: 400
    else
      render json: { uuid: course_form.model.uuid }
    end
  end

  def update
    course.update(course_params)
    render json: {uuid: course.uuid}
  end

  def destroy
    course.destroy
    render nothing: true
  end

  def register
    course = Course.find_by_identifier!(params[:id])
    begin
      course.add_student current_profile
      TrackerWrapper.new(course.teacher.user).track('Student Joined',
                                                    id: current_user.id,
                                                    name: current_user.name,
                                                    courseName: course.name,
                                                    courseUuid: course.uuid
                                                   )
      status = 200
    rescue ActiveRecord::RecordNotUnique
      status = 400
    end
    render nothing: true, status: status
  end

  def unregister
    course.students.destroy(current_profile)
    status = 200
    render nothing: true, status: status
  end

  def students
    @students = course.students
  end

  def search
    @course = Course.find_by_identifier!(params[:id])
  end

  private

  def course
    @course ||= current_profile.courses.find_by_identifier!(params[:id])
  end

  def course_params
    params.require(:course).permit(:name, :start_date, :end_date, :class_name, :grade, :institution)
  end
end
