class RenameFileToFileCarrierwaveOnMedias < ActiveRecord::Migration
  def change
    rename_column :medias, :file, :file_carrierwave
  end
end
