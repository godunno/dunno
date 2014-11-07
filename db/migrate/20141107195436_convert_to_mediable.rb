class ConvertToMediable < ActiveRecord::Migration
  def change
    ActiveRecord::Base.transaction do
      Media.find_each do |media|
        media.mediable = Topic.find_by(id: media.topic_id) || PersonalNote.find_by(id: media.personal_note_id)
        media.save!
      end
    end
  end
end
