class RemoveCategoryFromMedias < ActiveRecord::Migration
  def change
    remove_column :medias, :category, :string
  end
end
