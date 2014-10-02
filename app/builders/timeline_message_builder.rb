class TimelineMessageBuilder < BaseBuilder
  def build(json = Jbuilder.new, options = {})
    json.(timeline_message, :uuid, :content)
    json.created_at(format_time(timeline_message.created_at))
    json.up_votes(timeline_message.count_votes_up)
    json.down_votes(timeline_message.count_votes_down)

    json.author(timeline_message.student, :name, :avatar)
  end
end
