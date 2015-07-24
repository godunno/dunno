class WholePeriod
  attr_reader :day_in_month

  def initialize(day_in_month)
    @day_in_month = day_in_month
  end

  def month
    day_in_month.beginning_of_month..day_in_month.end_of_month
  end

  def week
    day_in_month.beginning_of_week..day_in_month.end_of_week
  end

  def day
    day_in_month.beginning_of_day..day_in_month.end_of_day
  end
end
