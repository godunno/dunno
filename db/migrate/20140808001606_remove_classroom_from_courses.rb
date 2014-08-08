class RemoveClassroomFromCourses < ActiveRecord::Migration
  def change
    remove_column :courses, :classroom, :string
  end
end
