class CourseEventsIndexerWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'elasticsearch', retry: false

  attr_reader :course
  delegate :start_date, to: :course

  def perform(course_id)
    @course = Course.find(course_id)
    index!
  end

  private

  def index!
    remove_from_index!
    insert_to_index!
  end

  def remove_from_index!
    SearchEventsByCourse.search(course, until_date: course.end_date).each do |event|
      Indexer.new(event).delete
    end
  end

  def insert_to_index!
    CourseScheduler.new(course, time_range).events.each do |event|
      Indexer.new(event).index
    end
  end

  def client
    @client ||= Elasticsearch::Client.new
  end

  def time_range
    start_date.beginning_of_day..end_date.end_of_day
  end

  def end_date
    course.end_date || course.events.last_published.try(:start_at) || Time.current
  end
end
