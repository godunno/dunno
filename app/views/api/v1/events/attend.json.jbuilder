json.(@event, :id, :uuid, :title, :start_at, :status, :channel)
json.duration(TimeOfDay.parse(@event.duration).second_of_day / 60)

json.(event_pusher_events, *event_pusher_events.events)

json.topics(@event.topics, :id, :description)
json.thermometers(@event.thermometers, :uuid, :content)
json.polls @event.polls do |poll|
  json.(poll, :uuid, :content, :released_at)
  json.options poll.options do |option|
    json.(option, :uuid, :content)
  end
end

json.medias @event.medias do |media|
  MediaBuilder.new(media).build!(json)
end

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


