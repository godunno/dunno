json.(timeline, :id, :start_at, :created_at, :updated_at)

json.messages timeline.timeline_interactions.messages do |message|
  json.message(message.interaction)
end
