class AddFolderToMedias < ActiveRecord::Migration
  def change
    add_reference :medias, :folder, index: true
  end
end
