class MonthsNavigation
  attr_reader :current_month

  def initialize(day_in_month)
    @current_month = (day_in_month.present? ? Time.zone.parse(day_in_month) : Time.current).beginning_of_month
  end

  def previous_month
    current_month - 1.month
  end

  def next_month
    current_month + 1.month
  end
end
