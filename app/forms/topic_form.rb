class TopicForm
  attr_reader :topic, :media

  def initialize(topic)
    @topic = topic
    @media = topic.media
  end

  def update!(topic_params)
    if media && description_present?(topic_params)
      media.update!(title: topic_params.delete(:description))
    else
      topic.update!(topic_params)
    end
  end

  private

  def description_present?(topic_params)
    topic_params[:description].present?
  end
end
