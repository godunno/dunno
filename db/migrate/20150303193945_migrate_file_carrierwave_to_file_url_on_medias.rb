class MigrateFileCarrierwaveToFileUrlOnMedias < ActiveRecord::Migration
  def change
    Media.where.not(file_carrierwave: nil).find_each do |media|
      media.original_filename = media[:file_carrierwave]
      media.file_url = media.file_carrierwave.path
      media.save!
    end
  end
end
