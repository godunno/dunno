class CreateTrackingEvents < ActiveRecord::Migration
  def change
    create_table :tracking_events do |t|
      t.integer :event_type
      t.belongs_to :trackable, polymorphic: true, index: true
      t.belongs_to :profile, index: true
      t.belongs_to :course, index: true

      t.timestamps
    end
  end
end
