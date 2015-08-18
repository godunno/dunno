class SearchEventsByCourse
  DEFAULT_PER_PAGE = 10

  attr_reader :course, :until_date, :per_page, :offset, :page

  def self.search(course, options)
    new(course, options).search
  end

  def initialize(course, options)
    @course     = course
    @until_date = options[:until]
    @per_page   = (options[:per_page] || DEFAULT_PER_PAGE).to_i
    @offset     = options[:offset].to_i
    @page       = [options[:page].to_i - 1, 0].max
  end

  def search
    Event.search(build_query)
    .map { |event| FindOrInitializeEvent.by(course, event._source) }
  end

  private

  def build_query
    builder = QueryBuilder.new
              .order_by(:start_at,  :desc)
              .filter_by_attribute(:course_id, course.id)
              .filter_by_range(:start_at, :lte, upper_bound_date)

    builder = if lower_bound_date?
                lower_bound_date(builder)
              else
                paginate(builder)
              end

    builder.build
  end

  def newest_event
    course.events.last_published
  end

  def upper_bound_date
    @upper_bound_date ||= newest_event.try(:start_at) || Time.current.end_of_day
  end

  def lower_bound_date?
    until_date.present? && until_date <= upper_bound_date
  end

  def lower_bound_date(builder)
    builder
      .filter_by_range(:start_at, :gte, until_date)
      .size(course.events.count)
  end

  def paginate(builder)
    builder
      .from(offset + (page * per_page))
      .size(per_page)
  end

  class QueryBuilder
    attr_reader :must, :sort

    def initialize
      @must = []
      @sort = []
      @from = 0
      @size = 10
    end

    def order_by(attribute, order)
      sort << { attribute => order }
      self
    end

    def filter_by_attribute(attribute, value)
      must << {
        filtered: {
          filter: {
            term: {
              attribute => value
            }
          }
        }
      }
      self
    end

    def filter_by_range(attribute, comparison, value)
      must << {
        range: {
          attribute => {
            comparison => value
          }
        }
      }
      self
    end

    def size(number)
      @size = number
      self
    end

    def from(number)
      @from = number
      self
    end

    def build
      {
        sort: sort,
        size: @size,
        from: @from,
        query: {
          bool: {
            must: must
          }
        }
      }
    end
  end
end
