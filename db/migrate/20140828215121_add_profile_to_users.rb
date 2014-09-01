class AddProfileToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :profile, index: true
    add_column :users, :profile_type, :string, index: true

    add_index :users, [:profile_id, :profile_type]
  end
end
