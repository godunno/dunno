class RemoveOrganizationFromStudents < ActiveRecord::Migration
  def change
    remove_reference :students, :organization, index: true
  end
end
