class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :name
      t.belongs_to :teacher, index: true
      t.belongs_to :organization, index: true

      t.timestamps
    end
  end
end
