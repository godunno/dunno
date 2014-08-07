class CreateWeeklySchedules < ActiveRecord::Migration
  def change
    create_table :weekly_schedules do |t|
      t.integer :weekday
      t.string :start_time
      t.string :end_time
      t.belongs_to :course, index: true

      t.timestamps
    end
  end
end
