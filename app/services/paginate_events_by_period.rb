class PaginateEventsByPeriod
  attr_accessor :day, :events

  def initialize(events, month)
    @day = month.present? ? Time.zone.parse(month) : Time.current
    @events = events.where(start_at: @day.beginning_of_month..@day.end_of_month)
  end
end
