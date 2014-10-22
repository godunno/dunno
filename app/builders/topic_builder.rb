class TopicBuilder < BaseBuilder
  def build(json = Jbuilder.new, options = {})
    json.(topic, :uuid, :description, :order, :done)
    if topic.media.present?
      json.media do
        MediaBuilder.new(topic.media).build!(json)
      end
    end
  end
end
