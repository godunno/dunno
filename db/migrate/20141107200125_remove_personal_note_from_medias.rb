class RemovePersonalNoteFromMedias < ActiveRecord::Migration
  def change
    remove_reference :medias, :personal_note, index: true
  end
end
