class EventPusher

  attr_reader :event

  def initialize(event)
    @event = event
  end

  def student_message(message)
    trigger(event.student_message_event, pusher_message_json(message))
  end

  def up_down_vote_message(message)
    trigger(event.up_down_vote_message_event, pusher_message_json(message))
  end

  def close
    trigger(event.close_event, pusher_close_event_json)
  end

  def release_poll(poll)
    trigger(event.release_poll_event, poll.uuid)
  end

  def pusher_message_json(message)
    Jbuilder.encode do |json|
      json.(message, :id, :created_at, :updated_at, :content)
      json.up_votes message.upvotes.size
      json.down_votes message.downvotes.size
      json.student(message.student, :id, :name, :email, :avatar)
    end
  end

  def pusher_close_event_json
    Jbuilder.encode do |json|
      json.(@event, :uuid, :start_at, :title)
      json.teacher(@event.teacher, :id, :name, :email, :avatar)
      json.thermometers(@event.thermometers, :uuid, :content)
    end
  end

  private

    def trigger(event_name, content)
      Pusher.trigger(event.channel, event_name, content)
    end
end
