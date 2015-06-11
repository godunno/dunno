class RemoveOrganizationIdFromCourses < ActiveRecord::Migration
  def change
    remove_column :courses, :organization_id, :integer
  end
end
