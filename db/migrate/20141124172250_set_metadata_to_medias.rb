class SetMetadataToMedias < ActiveRecord::Migration
  def change
    ActiveRecord::Base.transaction do
      Media.find_each do |media|
        if media.type == "url" && media.preview
          media.title = media.preview["title"]
          media.description = media.preview["description"]
          media.thumbnail = media.preview["images"].to_a[0].to_h["src"]
        else
          media.title = media.file_identifier
        end
      end
    end
  end
end
