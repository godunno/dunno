class RenameContentToDescriptionFromPersonalNotes < ActiveRecord::Migration
  def change
    rename_column :personal_notes, :content, :description
  end
end
