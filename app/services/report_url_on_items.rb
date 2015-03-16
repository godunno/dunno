class ReportUrlOnItems
  URL_REGEX = URI.regexp(%w(http https))

  def initialize(klass)
    @klass = klass
  end

  def with_url
    @with_url ||= @klass.find_each.select do |item|
      item.description =~ URL_REGEX
    end
  end

  def teachers_using_url
    @teachers_using_url ||= with_url.map { |item| item.try(:event).try(:course).try(:teacher) }.uniq
  end
end
