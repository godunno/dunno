class ChangeWeekdaysToArrayOfStringsOnCourses < ActiveRecord::Migration
  def change
    remove_column :courses, :weekdays, :string
    add_column :courses, :weekdays, :string, array: true
  end
end
