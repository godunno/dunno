class AddThumbnailToMedias < ActiveRecord::Migration
  def change
    add_column :medias, :thumbnail, :string
  end
end
