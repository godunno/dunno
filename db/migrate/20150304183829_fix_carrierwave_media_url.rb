class FixCarrierwaveMediaUrl < ActiveRecord::Migration
  def change
    Media.where.not(file_url: nil).find_each do |media|
      old_file_url = media.file_url
      media.file_url = old_file_url.sub('file_carrierwave', 'file')
      media.save!
    end
  end
end
