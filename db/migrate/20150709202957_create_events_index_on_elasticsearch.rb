class CreateEventsIndexOnElasticsearch < ActiveRecord::Migration
  def change
    Event.__elasticsearch__.create_index!
    Event.import
  end
end
