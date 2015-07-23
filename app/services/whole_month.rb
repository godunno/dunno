class WholeMonth
  attr_reader :day_in_month

  def initialize(day_in_month)
    @day_in_month = day_in_month
  end

  def range
    day_in_month.beginning_of_month..day_in_month.end_of_month
  end
end
