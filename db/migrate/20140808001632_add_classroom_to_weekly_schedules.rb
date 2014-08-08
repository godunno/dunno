class AddClassroomToWeeklySchedules < ActiveRecord::Migration
  def change
    add_column :weekly_schedules, :classroom, :string
  end
end
