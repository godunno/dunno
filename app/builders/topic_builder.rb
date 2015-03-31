class TopicBuilder < BaseBuilder
  def build(json = Jbuilder.new, options = {})
    json.(topic, :uuid, :description, :order, :done, :personal)
    if options[:show_media]
      json.media_id topic.media.try(:uuid)
      json.media do
        MediaBuilder.new(topic.media).build!(json)
      end
    end
  end
end
