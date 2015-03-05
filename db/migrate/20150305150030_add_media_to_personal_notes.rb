class AddMediaToPersonalNotes < ActiveRecord::Migration
  def change
    add_reference :personal_notes, :media, index: true
  end
end
