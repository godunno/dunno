class CourseEventsIndexerWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'elasticsearch', retry: false

  attr_reader :course

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
    CourseScheduler.new(course).events.each do |event|
      Indexer.new(event).index
    end
  end

  def client
    @client ||= Elasticsearch::Client.new
  end
end
