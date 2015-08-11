class CourseEventsIndexer
  attr_reader :course

  def self.index!(course)
    new(course).index!
  end

  def initialize(course)
    @course = course
  end

  def index!
    remove_from_index!
    insert_to_index!
  end

  private

  def remove_from_index!
    SearchEventsByCourse.search(course, until_date: course.end_date).each do |event|
      client.delete index: Event.index_name, type: 'event', id: event.index_id
    end
  end

  def insert_to_index!
    CourseScheduler.new(course).events.each do |event|
      client.index index: Event.index_name, type: 'event', id: event.index_id, body: event.as_indexed_json
    end
  end

  def client
    @client ||= Elasticsearch::Client.new
  end
end
