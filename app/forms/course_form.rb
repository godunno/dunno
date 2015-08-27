class CourseForm
  attr_reader :course

  def initialize(course, params)
    @course = course
    @params = params.with_indifferent_access
  end

  def update!
    course.attributes = params
    index_events
    persist_past_events
    course.save!
  end

  private

  def params
    @params
      .merge(date_for(:start_date))
      .merge(date_for(:end_date))
  end

  def date_for(attribute)
    if @params[attribute].present?
      { attribute => Time.zone.parse(@params[attribute]).to_date }
    else
      {}
    end
  end

  def index_events
    CourseEventsIndexerWorker.perform_async(course.id) if should_index_events?
  end

  def persist_past_events
    PersistPastEvents.new(course, since: course.start_date).persist! if should_persist_past_events?
  end

  def should_index_events?
    %w(start_date end_date).any? { |date| course.changes.key?(date) }
  end

  def should_persist_past_events?
    old_date, new_date = course.start_date_change
    old_date && new_date && new_date < old_date
  end
end
