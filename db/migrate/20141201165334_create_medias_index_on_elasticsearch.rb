class CreateMediasIndexOnElasticsearch < ActiveRecord::Migration
  def change
    Media.__elasticsearch__.create_index!
  end
end
