class AddOriginalFilenameToMedias < ActiveRecord::Migration
  def change
    add_column :medias, :original_filename, :string
  end
end
