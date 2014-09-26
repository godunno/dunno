class TimelineBuilder < BaseBuilder
  def build(json = Jbuilder.new, options = {})
    json.(timeline, :id, :start_at, :created_at, :updated_at)

    json.messages timeline.timeline_interactions.messages do |message|
      TimelineMessageBuilder.new(message.interaction).build!(json)
    end
  end
end
