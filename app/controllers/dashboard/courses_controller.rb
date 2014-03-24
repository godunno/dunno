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
    ActiveRecord::Base.transaction do
      @course.save
      duration = TimeOfDay.new(0) + Shift.new(@course.start_time, @course.end_time).duration
      schedule = Recurrence.new(every: :week, on: @course.weekdays, starts: @course.start_date, until: @course.end_date)
      schedule.each do |date|
        time = date.to_time.change(hour: @course.start_time.hour, min: @course.start_time.minute)
        @course.events << Event.new(start_at: time, duration: duration, status: "available", title: @course.name)
      end
    end
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
      params.require(:course).permit(:name, :organization_id, :start_date, :end_date, :start_time, :end_time, weekdays: [])
    end
end
