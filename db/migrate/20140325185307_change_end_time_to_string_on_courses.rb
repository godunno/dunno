class ChangeEndTimeToStringOnCourses < ActiveRecord::Migration
  def change
    change_column :courses, :end_time, :string
  end
end
