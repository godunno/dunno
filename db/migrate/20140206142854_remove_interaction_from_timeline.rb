class RemoveInteractionFromTimeline < ActiveRecord::Migration
  def change
    remove_column :timelines, :interaction_id
    remove_column :timelines, :interaction_type
  end
end
