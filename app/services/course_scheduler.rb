class CourseScheduler
  def initialize(course)
    @course = course
  end

  def schedule!
    schedule = CreateSchedule.new(
      @course.start_date,
      @course.end_date,
      @course.weekly_schedules
    ).schedule

    schedule.each do |event|
      Form::EventForm.create(
        course_id: @course.id,
        start_at: event.begin,
        end_at: event.end,
        classroom: event.classroom,
        status: "draft"
      )
    end
  end
end
