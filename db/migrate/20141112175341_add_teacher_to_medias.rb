class AddTeacherToMedias < ActiveRecord::Migration
  def change
    add_reference :medias, :teacher, index: true
  end
end
