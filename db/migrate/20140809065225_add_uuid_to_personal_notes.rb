class AddUuidToPersonalNotes < ActiveRecord::Migration
  def change
    add_column :personal_notes, :uuid, :uuid
    add_index :personal_notes, :uuid, unique: true
  end
end
