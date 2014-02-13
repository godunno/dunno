class EventPusher
  attr_reader :event
  def initialize(event)
    @event = event
  end

  def student_message(message)
    trigger(event.student_message_event, { content: message })
  end

  def up_down_vote_message(up, down)
    trigger(event.up_down_vote_message_event, { up: up, down: down })
  end

  private

    def trigger(event_name, content)
      Pusher.trigger(event.channel, event_name, content)
    end
end
