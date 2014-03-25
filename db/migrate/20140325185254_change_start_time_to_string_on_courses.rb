class ChangeStartTimeToStringOnCourses < ActiveRecord::Migration
  def change
    change_column :courses, :start_time, :string
  end
end
