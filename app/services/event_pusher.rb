class EventPusher

  attr_reader :event

  def initialize(event)
    @event = event
  end

  def student_message(message)
    trigger(StudentPusherEvents.new.student_message_event, pusher_message_json(message))
  end

  def up_down_vote_message(message)
    trigger(StudentPusherEvents.new.up_down_vote_message_event, pusher_message_json(message))
  end

  def close
    trigger(TeacherPusherEvents.new.close_event, pusher_close_event_json)
  end

  def release_poll(poll)
    trigger(TeacherPusherEvents.new.release_poll_event, pusher_poll_json(poll))
  end

  def pusher_message_json(poll)
    Jbuilder.encode do |json|
      json.(poll, :id, :uuid, :created_at, :updated_at, :content)
      json.up_votes message.upvotes.size
      json.down_votes message.downvotes.size
      json.student(message.student, :id, :name, :email, :avatar)
    end
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
      json.thermometers(@event.thermometers, :uuid, :content)
    end
  end

  def pusher_poll_json(poll)
    Jbuilder.encode do |json|
      json.(poll, :uuid, :content)
      json.event(poll.event, :uuid)
      json.options(poll.options, :uuid, :content)
    end
  end

  private

  def trigger(event_name, content)
    Pusher.trigger(event.channel, event_name, content)
  end
end
