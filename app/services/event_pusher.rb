class EventPusher
  attr_reader :event
  def initialize(event)
    @event = event
  end

  def student_message(message)
    trigger(event.student_message_event, pusher_message_json(message))
  end

  def up_down_vote_message(up, down)
    trigger(event.up_down_vote_message_event, { up: up, down: down })
  end

  def pusher_message_json(message)
    Jbuilder.encode do |json|
      json.(message, :id, :created_at, :updated_at, :content)
      json.student(message.student, :id, :name, :email, :avatar)
    end
  end

  private

    def trigger(event_name, content)
      Pusher.trigger(event.channel, event_name, content)
    end
end
