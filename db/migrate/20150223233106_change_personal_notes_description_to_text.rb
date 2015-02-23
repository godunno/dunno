class ChangePersonalNotesDescriptionToText < ActiveRecord::Migration
  def change
    change_column :personal_notes, :description, :text
  end
end
