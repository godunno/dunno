module ApiHelper
  def format_time(time)
    time.try(:utc).try(:iso8601)
  end
end
