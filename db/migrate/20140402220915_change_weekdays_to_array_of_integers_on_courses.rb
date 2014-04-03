class ChangeWeekdaysToArrayOfIntegersOnCourses < ActiveRecord::Migration
  def change
    remove_column :courses, :weekdays, :string, array: true
    add_column :courses, :weekdays, :integer, array: true
  end
end
