class CreateIndexForEvents < ActiveRecord::Migration
  def change
    begin
      Event.__elasticsearch__.delete_index!
    rescue Elasticsearch::Transport::Transport::Errors::NotFound => e
      puts 'Index not found.'
    ensure
      Event.__elasticsearch__.create_index!
      Course.transaction do
        Course.find_each do |course|
          CourseEventsIndexer.index!(course)
        end
      end
    end
  end
end
