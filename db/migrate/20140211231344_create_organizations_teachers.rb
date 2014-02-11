class CreateOrganizationsTeachers < ActiveRecord::Migration
  def change
    create_table :organizations_teachers, id: false do |t|
      t.belongs_to :organization, null: false
      t.belongs_to :teacher, null: false
    end
  end
end
