class EventBuilder < BaseBuilder
  def build(json = Jbuilder.new, options = {})
    json.(event, :id, :uuid, :channel, :status, :order)
    json.start_at event.start_at.to_i
    json.end_at event.end_at.to_i
    event_pusher_events = options[:event_pusher_events]
    if event_pusher_events
      json.(event_pusher_events, *event_pusher_events.events)
    end

    json.previous do
      json.uuid event.previous.try(:uuid)
    end
    json.next do
      json.uuid event.next.try(:uuid)
    end

    if options[:show_course]
      json.course do
        CourseBuilder.new(event.course).build!(json, show_events: false)
      end
    end

    if options[:role] == :teacher
      json.personal_notes event.personal_notes do |personal_note|
        PersonalNoteBuilder.new(personal_note).build!(json)
      end
    end

    json.timeline do
      TimelineBuilder.new(event.timeline).build!(json)
    end

    json.topics event.topics do |topic|
      TopicBuilder.new(topic).build!(json)
    end

    json.thermometers event.thermometers do |thermometer|
      ThermometerBuilder.new(thermometer).build!(json)
    end

    json.polls event.polls do |poll|
      PollBuilder.new(poll).build!(json)
    end

    json.medias event.medias do |media|
      MediaBuilder.new(media).build!(json)
    end
  end
end
