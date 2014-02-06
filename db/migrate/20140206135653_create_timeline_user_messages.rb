class CreateTimelineUserMessages < ActiveRecord::Migration
  def change
    create_table :timeline_user_messages do |t|
      t.text :content
      t.belongs_to :timeline, index: true

      t.timestamps
    end
  end
end
