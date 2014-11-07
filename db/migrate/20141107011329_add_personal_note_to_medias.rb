class AddPersonalNoteToMedias < ActiveRecord::Migration
  def change
    add_reference :medias, :personal_note, index: true
  end
end
