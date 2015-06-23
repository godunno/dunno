class AddProfileToMedias < ActiveRecord::Migration
  def change
    add_reference :medias, :profile, index: true
  end
end
