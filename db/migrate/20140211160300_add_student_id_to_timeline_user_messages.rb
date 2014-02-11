class AddStudentIdToTimelineUserMessages < ActiveRecord::Migration
  def change
    change_table :timeline_user_messages do |t|
      t.references :student
    end
    add_index :timeline_user_messages, :student_id
  end
end
