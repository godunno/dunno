class AddTimelineIdToArtifacts < ActiveRecord::Migration
  def change
    add_reference :artifacts, :timeline, index: true
  end
end
