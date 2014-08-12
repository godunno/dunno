class AddIndexToCoursesStudents < ActiveRecord::Migration
  def change
    add_index :courses_students, [:course_id, :student_id], unique: true
  end
end
