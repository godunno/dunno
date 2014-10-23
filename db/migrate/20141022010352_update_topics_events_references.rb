class UpdateTopicsEventsReferences < ActiveRecord::Migration
  def change
    ActiveRecord::Base.transaction do
      Artifact.where(heir_type: 'Topic').find_each do |artifact|
        topic = Topic.find(artifact.heir_id)
        topic.event = artifact.event
        topic.save!
        artifact.destroy!
      end
    end
  end
end
