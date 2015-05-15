class RemoveOldTables < ActiveRecord::Migration
  def change
    drop_table :answers
    drop_table :artifacts
    drop_table :attendances
    drop_table :beacons
    drop_table :options
    drop_table :organizations
    drop_table :organizations_teachers
    drop_table :personal_notes
    drop_table :polls
    drop_table :ratings
    drop_table :thermometers
    drop_table :timeline_interactions
    drop_table :timeline_messages
    drop_table :timelines
    drop_table :votes
  end
end
