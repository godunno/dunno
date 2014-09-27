class TimelineBuilder < BaseBuilder
  def build(json = Jbuilder.new, options = {})
    json.start_at(format_time(timeline.start_at))
    json.updated_at(format_time(timeline.updated_at))

    json.messages timeline.timeline_interactions.messages do |message|
      TimelineMessageBuilder.new(message.interaction).build!(json)
      voter = options[:voter]
      if voter
        json.already_voted message.interaction.vote_by(voter)
      end
    end
  end
end
