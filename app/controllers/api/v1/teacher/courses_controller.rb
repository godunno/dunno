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

    # TODO: extract to service!
    begin
      ActiveRecord::Base.transaction do
        @course.save!
        start_time = TimeOfDay.parse(@course.start_time)
        end_time = TimeOfDay.parse(@course.end_time)
        duration = TimeOfDay.new(0) + Shift.new(start_time, end_time).duration
        schedule = Recurrence.new(every: :week, on: @course.weekdays, starts: @course.start_date, until: @course.end_date)
        schedule.each do |date|
          time = date.to_time.change(hour: start_time.hour, min: start_time.minute)
          event = Form::EventForm.new(course_id: @course.id, start_at: time, duration: duration.to_s, status: "available", title: @course.name)
          unless event.save
            @course.errors.add(:events, event.errors)
            raise ActiveRecord::RecordInvalid.new(event)
          end
        end
      end
    rescue ActiveRecord::RecordInvalid
      render json: {errors: @course.errors}, status: 400
    else
      render nothing: true
    end
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
    ###############################################
    # TODO: Look for a bug fix on Rails           #
    # This code fixes a bug on Request#deep_munge #
    params[:course][:weekdays] ||= []
    ###############################################

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
