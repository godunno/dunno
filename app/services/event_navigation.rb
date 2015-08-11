class EventNavigation
  attr_reader :original_event

  def initialize(event)
    @original_event = event
  end

  def previous
    events.detect { |e| e.order == event.order - 1 }
  end

  def next
    events.detect { |e| e.order == event.order + 1 }
  end

  private

  def event
    @event ||= events.detect { |e| e.start_at == original_event.start_at }
  end

  def events
    @events ||= CourseScheduler.new(original_event.course).events
  end
end
