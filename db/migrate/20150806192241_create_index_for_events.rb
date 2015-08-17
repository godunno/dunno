class CreateIndexForEvents < ActiveRecord::Migration
  def change
    begin
      Event.__elasticsearch__.delete_index!
    rescue Elasticsearch::Transport::Transport::Errors::NotFound => e
      puts 'Index not found.'
    ensure
      Event.__elasticsearch__.create_index!
      Event.import
    end
  end
end
