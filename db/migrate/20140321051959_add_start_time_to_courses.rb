class AddStartTimeToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :start_time, :text
  end
end
