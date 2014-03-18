class AddCourseToEvents < ActiveRecord::Migration
  def change
    add_reference :events, :course, index: true
  end
end
