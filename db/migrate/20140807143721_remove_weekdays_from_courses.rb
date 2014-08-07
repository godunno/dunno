class RemoveWeekdaysFromCourses < ActiveRecord::Migration
  def change
    remove_column :courses, :weekdays, :integer, array: true
  end
end
