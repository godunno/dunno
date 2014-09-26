class AddUuidToTimelineMessages < ActiveRecord::Migration
  def change
    add_column :timeline_messages, :uuid, :uuid
    add_index :timeline_messages, :uuid, unique: true
  end
end
