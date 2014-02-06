class CreateTimelineInteractions < ActiveRecord::Migration
  def change
    create_table :timeline_interactions do |t|
      t.integer :interaction_id, null: false
      t.string :interaction_type, null: false
      t.belongs_to :timeline, index: true


      t.timestamps
    end
  end
end
