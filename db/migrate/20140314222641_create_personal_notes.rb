class CreatePersonalNotes < ActiveRecord::Migration
  def change
    create_table :personal_notes do |t|
      t.string :content
      t.boolean :done
      t.belongs_to :event, index: true

      t.timestamps
    end
  end
end
