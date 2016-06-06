class EventNavigation
  attr_reader :event

  def initialize(event)
    @event = event
  end

  def previous
    return unless event_index > 0
    events[event_index - 1]
  end

  def next
    if scheduled?
      events[event_index + 1]
    else
      events[event_index]
    end
  end

  private

  def event_index
    @event_index ||= events.take_while { |e| e.start_at < event.start_at }.count
  end

  def scheduled?
    @scheduled ||= events.find_index { |e| e.start_at == event.start_at }.present?
  end

  def events
    @events ||= CourseScheduler.new(event.course, time_range).events
  end

  def time_range
    (event.start_at - 1.week)..(event.start_at + 1.week)
  end
end
