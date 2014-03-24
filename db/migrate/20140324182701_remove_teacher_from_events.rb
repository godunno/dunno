class RemoveTeacherFromEvents < ActiveRecord::Migration
  def change
    remove_reference :events, :teacher, index: true
  end
end
