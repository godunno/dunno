class UpdateFileFromMedias < ActiveRecord::Migration
  def change
    Media.transaction do
      Media.where.not(file: nil).find_each do |media|
        media.original_filename = media[:file]
        media[:file] = media.file.path
        media.save!
      end
    end
  end
end
