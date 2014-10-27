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

    schedule.each do |range|
      Form::EventForm.create(
        course_id: @course.id,
        start_at: range.begin,
        end_at: range.end,
        status: "draft"
      )
    end
  end
end
