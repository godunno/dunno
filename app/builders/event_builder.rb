class EventBuilder < BaseBuilder
  def build(json = Jbuilder.new, options = {})
    json.(event, :id, :uuid, :channel, :order)
    json.status(event.formatted_status)
    json.start_at(format_time(event.start_at))
    json.end_at(format_time(event.end_at))
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

    if options[:personal_notes]
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
