class AddIndexToOrganizationsUuid < ActiveRecord::Migration
  def change
    ActiveRecord::Base.transaction do
      remove_index :organizations, :uuid
      add_index :organizations, :uuid, unique: true
    end
  end
end
