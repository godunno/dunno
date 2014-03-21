class AddClassroomToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :classroom, :string
  end
end
