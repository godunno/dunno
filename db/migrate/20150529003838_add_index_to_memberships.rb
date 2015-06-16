class AddIndexToMemberships < ActiveRecord::Migration
  def change
    add_index :memberships, [:course_id, :profile_id], unique: true
  end
end
