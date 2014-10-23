class RemoveEventFromMedias < ActiveRecord::Migration
  def change
    remove_reference :medias, :event, index: true
  end
end
