class ChangeCategoryToStringOnMedias < ActiveRecord::Migration
  def change
    change_column :medias, :category, :string
  end
end
