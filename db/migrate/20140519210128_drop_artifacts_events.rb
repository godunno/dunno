class DropArtifactsEvents < ActiveRecord::Migration
  def change
    drop_table :artifacts_events
  end
end
