class RemoveOrganizationIndexFromCourses < ActiveRecord::Migration
  def change
    remove_index :courses, :organization_id
  end
end
