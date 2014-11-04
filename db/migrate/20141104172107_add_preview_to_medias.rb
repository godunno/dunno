class AddPreviewToMedias < ActiveRecord::Migration
  def change
    add_column :medias, :preview, :json
  end
end
