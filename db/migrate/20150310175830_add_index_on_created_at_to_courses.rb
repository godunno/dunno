class AddIndexOnCreatedAtToCourses < ActiveRecord::Migration
  def change
    add_index :courses, :created_at
  end
end
