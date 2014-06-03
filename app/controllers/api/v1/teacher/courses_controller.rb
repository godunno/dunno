class Api::V1::Teacher::CoursesController < Api::V1::TeacherApplicationController
  respond_to :json

  def index
    @courses = current_teacher.courses
    respond_with @courses.to_json(root: false)
  end

  def show
    if course
      respond_with course.to_json(include: :events)
    else
      render nothing: true, status: 404
    end
  end

  def destroy
    course.destroy
    render nothing: true
  end

  def create
    @course = Course.new(course_params)
    @course.teacher = current_teacher

    ActiveRecord::Base.transaction do
      @course.save
      start_time = TimeOfDay.parse(@course.start_time)
      end_time = TimeOfDay.parse(@course.end_time)
      duration = TimeOfDay.new(0) + Shift.new(start_time, end_time).duration
      schedule = Recurrence.new(every: :week, on: @course.weekdays, starts: @course.start_date, until: @course.end_date)
      schedule.each do |date|
        time = date.to_time.change(hour: start_time.hour, min: start_time.minute)
        @course.events << Event.new(start_at: time, duration: duration.to_s, status: "available", title: @course.name)
      end
    end
    @course.save
    render nothing: true
  end

  def update
    course.update(course_params)
    render nothing: true
  end


  private

    def course
      @course ||= current_teacher.courses.
        where(uuid: params[:id]).first
    end

    def course_params
      params.require(:course).
        permit(:name,
               :organization_id,
               :start_date,
               :end_date,
               :start_time,
               :end_time,
               :classroom,
               weekdays: [])
    end
end
