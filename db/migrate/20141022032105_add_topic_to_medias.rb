class AddTopicToMedias < ActiveRecord::Migration
  def change
    add_reference :medias, :topic, index: true
  end
end
