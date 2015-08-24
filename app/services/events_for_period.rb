class EventsForPeriod
  attr_reader :course, :time_range

  def initialize(course, time_range)
    @course = course
    @time_range = time_range
  end

  def events
    past_events + future_events
  end

  private

  def past_events
    course.events.where(start_at: time_range.begin..today)
  end

  def future_events
    CourseScheduler.new(course, today..time_range.end).events
  end

  def today
    1.day.from_now.end_of_day
  end
end
