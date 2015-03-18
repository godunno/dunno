class MigratePersonalNotesToPersonalTopics < ActiveRecord::Migration
  def change
    PersonalNote.find_each do |personal_note|
      Topic.create!(
        description: personal_note.description,
        order: personal_note.order,
        done: personal_note.done,
        event: personal_note.event,
        media: personal_note.media,
        personal: true
      )
      personal_note.destroy!
    end
  end
end
