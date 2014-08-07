class RemoveEndTimeFromCourses < ActiveRecord::Migration
  def change
    remove_column :courses, :end_time, :string
  end
end
