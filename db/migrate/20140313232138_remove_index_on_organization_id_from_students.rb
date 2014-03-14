class RemoveIndexOnOrganizationIdFromStudents < ActiveRecord::Migration
  def up
    remove_index :students, :organization_id
  end

  def down
    add_index :students, :organization_id
  end
end
