class Dashboard::CoursesController < Dashboard::ApplicationController
  respond_to :html, only: [:new, :edit, :index]

  def index
    @courses = current_teacher.courses
    respond_with @courses
  end

  def new
    @course = Course.new(teacher: current_teacher)
  end

  def create
    @course = Course.new(course_params)
    @course.teacher = current_teacher
    @course.save
    redirect_to action: :index
  end

  def edit
    course
  end

  def update
    course.update_attributes(course_params)
    redirect_to action: :index
  end

  def destroy
    course.destroy
    redirect_to action: :index
  end

  private

    def course
      @course ||= Course.where(uuid: params[:id]).first!
    end

    def course_params
      params.require(:course).permit(:name, :organization_id)
    end
end
