class AddInstitutionToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :institution, :string
  end
end
