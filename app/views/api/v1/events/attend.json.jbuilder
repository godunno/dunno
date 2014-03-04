json.(@event, :id, :uuid, :organization_id, :title, :duration, :start_at)
json.(@event, :channel, :student_message_event, :up_down_vote_message_event, :receive_poll_event, :receive_rating_event)
json.teacher(@event.teacher, :id, :name, :email, :avatar)
json.topics(@event.topics, :id, :description)
json.timeline do
  json.(@event.timeline, :id, :start_at, :created_at, :updated_at)

  #needs filter messages/poll/rating/etc
  json.messages @event.timeline.interactions do |interaction|
    json.id interaction.id
    json.content interaction.content
    json.created_at interaction.created_at
    json.updated_at interaction.updated_at
    json.up_votes interaction.upvotes.size
    json.down_votes interaction.downvotes.size
    json.student interaction.student
  end
end


