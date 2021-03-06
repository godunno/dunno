class EventsForPeriod
  attr_reader :course, :past_range, :future_range

  def initialize(course, time_range)
    @course = course
    @past_range, @future_range = split_past_and_future_events(time_range)
  end

  def events
    past_events + future_events
  end

  private

  def past_events
    course.events.where(start_at: past_range)
  end

  def future_events
    CourseScheduler.new(course, future_range).events
  end

  def split_past_and_future_events(time_range)
    date_range = time_range_to_date_range(time_range)

    past_dates, future_dates = date_range.partition do |date|
      date < Date.current
    end

    [array_to_time_range(past_dates), array_to_time_range(future_dates)]
  end

  def time_range_to_date_range(time_range)
    time_range.begin.to_date..time_range.end.to_date
  end

  def array_to_time_range(array)
    return nil..nil if array.empty?
    array.first.in_time_zone.beginning_of_day..array.last.in_time_zone.end_of_day
  end
end
