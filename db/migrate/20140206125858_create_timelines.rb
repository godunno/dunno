class CreateTimelines < ActiveRecord::Migration
  def change
    create_table :timelines do |t|
      t.datetime :start_at, null: false
      t.integer :interaction_id, null: false
      t.string :interaction_type, null: false
      t.belongs_to :event

      t.timestamps
    end

    add_index :timelines, :interaction_id
    add_index :timelines, :interaction_type
    add_index :timelines, :event_id
  end
end
