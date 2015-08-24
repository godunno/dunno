class PersistPastEvents
  attr_reader :course, :start_at
  delegate :events, to: :scheduler

  def initialize(course, since: Time.current)
    @course = course
    @start_at = since.beginning_of_day
  end

  def persist!
    events.each(&:save!)
  end

  private

  def scheduler
    CourseScheduler.new(course, start_at..end_at)
  end

  def end_at
    1.day.from_now.end_of_day
  end
end
