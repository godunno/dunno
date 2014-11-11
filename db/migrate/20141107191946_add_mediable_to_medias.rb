class AddMediableToMedias < ActiveRecord::Migration
  def change
    add_reference :medias, :mediable, polymorphic: true, index: true
  end
end
