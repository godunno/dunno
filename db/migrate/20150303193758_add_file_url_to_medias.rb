class AddFileUrlToMedias < ActiveRecord::Migration
  def change
    add_column :medias, :file_url, :string
  end
end
