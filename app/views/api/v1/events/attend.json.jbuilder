json.(@event, :id, :uuid, :organization_id, :title, :start_at)
json.duration(@event.duration.second_of_day / 60)
json.(@event, :channel, :student_message_event, :up_down_vote_message_event, :receive_poll_event, :receive_rating_event, :close_event)

json.teacher(@event.teacher, :id, :name, :email, :avatar)
json.topics(@event.topics, :id, :description)
json.thermometers(@event.thermometers, :uuid, :content)

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
    vote = interaction.votes.where(voter_id: current_student.id, voter_type: "Student").first
    if vote
      json.already_voted vote.vote_flag ? "up" : "down"
    end
  end
end


