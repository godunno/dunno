class MigrateMediasReferenceToMediable < ActiveRecord::Migration
  def change
    Media.find_each do |media|
      mediable = media.mediable
      next unless mediable.present?
      mediable.media = media
      mediable.save!
    end
  end
end
