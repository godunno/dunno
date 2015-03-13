class AddClassroomToEvents < ActiveRecord::Migration
  def change
    add_column :events, :classroom, :string
  end
end
