class Api::V1::Teacher::CoursesController < Api::V1::TeacherApplicationController
  respond_to :json

  def index
    @courses = current_teacher.courses
    respond_with @courses
  end

  def show
    @day = params[:month].present? ? Time.parse(params[:month]) : Time.now
    @events = course.events.where(start_at: @day.beginning_of_month..@day.end_of_month)
    fresh_when(last_modified: course.updated_at, etag: [course, params[:month]])
  end

  def destroy
    course.destroy
    render nothing: true
  end

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

  def update
    course.update(course_params)
    render json: {uuid: course.uuid}
  end

  def students
    @students = course.students
  end

  private

    def course
      @course ||= current_teacher.courses.find_by!(uuid: params[:id])
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
