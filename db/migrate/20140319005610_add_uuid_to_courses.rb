class AddUuidToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :uuid, :string
    add_index :courses, :uuid, unique: true
  end
end
