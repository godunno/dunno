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
    CourseScheduler.new(course, start_date..end_date)
  end

  def start_date
    course.start_date || course.created_at
  end

  def end_date
    1.day.from_now
  end
end
