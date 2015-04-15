class TopicForm
  attr_reader :topic, :media

  def initialize(topic)
    @topic = topic
    @media = topic.media
  end

  def update!(topic_params)
    if media
      media.update!(title: topic_params.delete(:description))
    end
    topic.update!(topic_params)
  end
end
