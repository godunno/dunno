class AddOrganizationIdToStudent < ActiveRecord::Migration
  def change
    change_table :students do |t|
      t.integer :organization_id, null: false, index: true
    end

    add_index :students, :organization_id
  end
end
