class EventNavigation
  attr_reader :event

  def initialize(event)
    @event = event
  end

  def previous
    events[event_index - 1] if event_index > 0
  end

  def next
    events[event_index + 1]
  end

  private

  def event_index
    @event_index ||= events.find_index { |e| e.start_at == event.start_at }
  end

  def events
    @events ||= CourseScheduler.new(event.course, WholePeriod.new(event.start_at).month).events
  end
end
