class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :name
      t.string :uuid

      t.timestamps
    end

    add_index :organizations, :uuid, unique: false
  end
end
