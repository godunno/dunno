class RemoveTopicFromMedias < ActiveRecord::Migration
  def change
    remove_reference :medias, :topic, index: true
  end
end
