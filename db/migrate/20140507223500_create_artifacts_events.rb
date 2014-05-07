class CreateArtifactsEvents < ActiveRecord::Migration
  def change
    create_table :artifacts_events, id: false do |t|
      t.belongs_to :artifact, index: true
      t.belongs_to :event, index: true
    end
  end
end
