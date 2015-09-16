class TransferTopic
  attr_reader :topic
  delegate :event, to: :topic

  def initialize(topic)
    @topic = topic
  end

  def transfer
    return false unless next_event.present?
    topic.update(event: next_event)
  end

  private

  def next_event
    @next_event ||= find_next_event
  end

  def find_next_event
    e = event
    loop do
      e = EventNavigation.new(e).next
      break unless e.present? && e.canceled?
    end
    e
  end
end
