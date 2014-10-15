class EventPusher
  attr_reader :event

  def initialize(event)
    @event = event
    @student_pusher_events = EventPusherEvents.new(User.new(profile: Student.new))
    @teacher_pusher_events = EventPusherEvents.new(User.new(profile: Teacher.new))
  end

  def student_message(message)
    trigger(@student_pusher_events.student_message_event, pusher_message_json(message))
  end

  def up_down_vote_message(message)
    trigger(@student_pusher_events.up_down_vote_message_event, pusher_message_json(message))
  end

  def close
    trigger(@teacher_pusher_events.close_event, pusher_close_event_json)
  end

  def release_poll(poll)
    trigger(@teacher_pusher_events.release_poll_event, pusher_poll_json(poll))
  end

  def release_media(media)
    trigger(@teacher_pusher_events.release_media_event, pusher_media_json(media))
  end

  def pusher_message_json(poll)
    Jbuilder.encode do |json|
      json.(poll, :id, :uuid, :created_at, :updated_at, :content)
      json.up_votes message.get_upvotes.size
      json.down_votes message.get_downvotes.size
      json.student(message.student, :id, :name, :email)
    end
  end

  def pusher_message_json(message)
    Jbuilder.encode do |json|
      json.(message, :id, :created_at, :updated_at, :content)
      json.up_votes message.get_upvotes.size
      json.down_votes message.get_downvotes.size
      json.student(message.student, :id, :name, :email)
    end
  end

  def pusher_close_event_json
    Jbuilder.encode do |json|
      json.(@event, :uuid, :start_at, :end_at)
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

  def pusher_media_json(media)
    Jbuilder.encode do |json|
      json.(media, :uuid, :title, :description, :url, :category)
      json.event(media.event, :uuid)
    end
  end

  private

    def trigger(event_name, content)
      Pusher.trigger(event.channel, event_name, content)
    end
end
