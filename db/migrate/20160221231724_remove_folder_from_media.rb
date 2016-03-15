class RemoveFolderFromMedia < ActiveRecord::Migration
  def change
    remove_reference :medias, :folder, index: true
  end
end
