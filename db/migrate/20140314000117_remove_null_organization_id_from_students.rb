class RemoveNullOrganizationIdFromStudents < ActiveRecord::Migration
  def up
    change_column :students, :organization_id, :integer, null: true
  end

  def down
    change_column :students, :organization_id, :integer, null: false
  end
end
