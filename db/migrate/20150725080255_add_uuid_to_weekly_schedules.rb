class AddUuidToWeeklySchedules < ActiveRecord::Migration
  def change
    add_column :weekly_schedules, :uuid, :uuid
    add_index :weekly_schedules, :uuid, unique: true
  end
end
