class AddClassNameToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :class_name, :string
  end
end
