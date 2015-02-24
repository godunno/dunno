class PaginateEventsByMonth
  attr_reader :current_month

  def initialize(events, day_in_month)
    @all_events = events.order(:start_at)

    if day_in_month.blank? && events_for_month.empty? && all_events.any?
      @current_month = next_month_with_event || last_month_with_event
    else
      day_in_month ||= Time.current
      @current_month = day_in_month.to_time.in_time_zone.beginning_of_month
    end
  end

  def next_month
    current_month + 1.month
  end

  def previous_month
    current_month - 1.month
  end

  def events
    @events ||= events_for_month(current_month)
  end

  private

  attr_reader :all_events

  def month_for(day_in_month)
    day_in_month.to_time.in_time_zone.beginning_of_month
  end

  def events_for_month(month = Time.current)
    full_month = month.beginning_of_month..month.end_of_month
    all_events.where(start_at: full_month)
  end

  def next_month_with_event
    event = all_events.where('start_at > ?', Time.current).first
    event && event.start_at.beginning_of_month
  end

  def last_month_with_event
    event = all_events.where('start_at < ?', Time.current).last
    event && event.start_at.beginning_of_month
  end
end
