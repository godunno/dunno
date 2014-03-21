class AddWeekdaysToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :weekdays, :string
  end
end
