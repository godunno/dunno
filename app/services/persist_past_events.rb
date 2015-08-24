class PersistPastEvents
  attr_reader :course
  delegate :events, to: :scheduler

  def initialize(course)
    @course = course
  end

  def persist!
    events.each(&:save!)
  end

  private

  def scheduler
    CourseScheduler.new(course, start_at..end_at)
  end

  def start_at
    course.start_date.beginning_of_day
  end

  def end_at
    1.day.from_now.end_of_day
  end
end
