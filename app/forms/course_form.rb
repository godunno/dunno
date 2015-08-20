class CourseForm
  attr_reader :course

  def initialize(course, params)
    @course = course
    @params = params.with_indifferent_access
  end

  def update!
    course.attributes = params
    CourseEventsIndexerWorker.perform_async(course.id) if should_index_events?
    PersistPastEvents.new(course).persist! if should_persist_past_events?
    course.save!
  end

  private

  def params
    @params
      .merge(date_for(:start_date))
      .merge(date_for(:end_date))
  end

  def date_for(attribute)
    if @params.key?(attribute)
      { attribute => Time.zone.parse(@params[attribute]).to_date }
    else
      {}
    end
  end

  def should_index_events?
    %w(start_date end_date).any? { |date| course.changes.key?(date) }
  end

  def should_persist_past_events?
    old_date, new_date = course.start_date_change
    old_date && new_date && new_date < old_date
  end
end
