class RemoveOrganizationFromEvents < ActiveRecord::Migration
  def change
    remove_reference :events, :organization, index: true
  end
end
