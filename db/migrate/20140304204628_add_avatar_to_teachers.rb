class AddAvatarToTeachers < ActiveRecord::Migration
  def change
    add_column :teachers, :avatar, :string
  end
end
