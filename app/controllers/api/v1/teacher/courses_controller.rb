class Api::V1::Teacher::CoursesController < Api::V1::TeacherApplicationController
  respond_to :json

  def index
    @courses = current_teacher.courses.includes(:weekly_schedules)
    respond_with @courses #.to_json(root: false)
  end

  def show
    fresh_when(course)
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
