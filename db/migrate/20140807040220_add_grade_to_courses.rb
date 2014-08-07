class AddGradeToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :grade, :string
  end
end
