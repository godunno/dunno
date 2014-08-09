class AddAccessCodeToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :access_code, :string
  end
end
