class AddTeacherIdToEvent < ActiveRecord::Migration
  def change
    change_table :events do |t|
      t.references :teacher, null: false
    end

    add_index :events, :teacher_id
  end
end
