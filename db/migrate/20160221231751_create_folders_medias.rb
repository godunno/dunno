class CreateFoldersMedias < ActiveRecord::Migration
  def change
    create_table :folders_medias, id: false do |t|
      t.belongs_to :folder, index: true
      t.belongs_to :media, index: true
    end
  end
end
