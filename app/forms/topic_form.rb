class TopicForm
  attr_reader :topic, :params

  def initialize(topic, params)
    @topic = topic
    @params = params
  end

  def create!(event)
    topic.order = event.topics.first.try(:order).to_i + 1
    topic.update!(params)
    update_media!
  end

  def update!
    update_media!
    topic.update!(params)
  end

  private

  def media
    topic.media
  end

  def update_media!
    return unless media
    media.update!(title: params.delete(:description))
  end
end
