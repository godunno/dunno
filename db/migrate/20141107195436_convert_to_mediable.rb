class ConvertToMediable < ActiveRecord::Migration
  def change
    ActiveRecord::Base.transaction do
      Media.find_each do |media|
        media.mediable = media.topic || media.personal_note
        media.save!
      end
    end
  end
end
