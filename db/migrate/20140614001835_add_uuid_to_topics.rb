class AddUuidToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :uuid, :uuid
    add_index :topics, :uuid, unique: true
  end
end
