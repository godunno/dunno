class EventNavigation
  attr_reader :original_event

  def initialize(event)
    @original_event = event
  end

  def previous
    events[event_index - 1] if event_index > 0
  end

  def next
    events[event_index + 1]
  end

  private

  def event_index
    @event_index ||= events.find_index { |e| e.start_at == original_event.start_at }
  end

  def events
    @events ||= CourseScheduler.new(original_event.course).events
  end
end
