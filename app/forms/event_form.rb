class EventForm
  attr_reader :event, :params

  def initialize(event, params)
    @event = event
    @params = params
  end

  def update!
    Event.transaction do
      reorder_topics!
      event.update!(params.except(:topics))
    end
  end

  private

  def reorder_topics!
    topics.reverse.each_with_index do |topic, index|
      topic.update!(order: index)
    end
  end

  def topics
    (params[:topics] || []).map { |topic| event.topics.find_by!(uuid: topic["uuid"]) }
  end
end
