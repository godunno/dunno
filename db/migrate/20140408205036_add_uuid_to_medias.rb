class AddUuidToMedias < ActiveRecord::Migration
  def change
    add_column :medias, :uuid, :string
    add_index :medias, :uuid, unique: true
  end
end
