class PaginateEventsByMonth
  attr_reader :current_month, :events

  def initialize(events, day_in_month)
    day_in_month ||= Time.current
    @current_month = day_in_month.to_time.in_time_zone.beginning_of_month
    @events = events.where(start_at: @current_month..@current_month.end_of_month)
  end

  def next_month
    @current_month + 1.month
  end

  def previous_month
    @current_month - 1.month
  end
end
