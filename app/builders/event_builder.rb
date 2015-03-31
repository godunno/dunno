class EventBuilder < BaseBuilder
  def build(json = Jbuilder.new, options = {})
    json.(event, :id, :uuid, :channel, :order, :status, :formatted_status)
    json.start_at(format_time(event.start_at))
    json.end_at(format_time(event.end_at))
    json.formatted_classroom([event.course.class_name, event.classroom].compact.join(' - '))
    event_pusher_events = options[:event_pusher_events]
    if event_pusher_events
      json.(event_pusher_events, *event_pusher_events.events)
    end

    if options[:show_neighbours]
      json.previous do
        EventBuilder.new(event.previous).build!(json, show_topics: { show_media: true }) if event.previous.present?
      end

      json.next do
        EventBuilder.new(event.next).build!(json, show_topics: { show_media: true }) if event.next.present?
      end
    end

    if options[:show_course]
      json.course do
        CourseBuilder.new(event.course).build!(json)
      end
    end

    if options[:show_personal_notes]
      json.personal_notes event.personal_notes do |personal_note|
        PersonalNoteBuilder.new(personal_note).build!(json, options[:show_personal_notes])
      end
    end

    if options[:show_timeline]
      json.timeline do
        TimelineBuilder.new(event.timeline).build!(json)
      end
    end

    if options[:show_topics]
      topics = if options[:show_topics].try(:[], :show_personal)
                 event.topics
               else
                 event.topics.without_personal
               end
      json.topics topics do |topic|
        TopicBuilder.new(topic).build!(json, options[:show_topics])
      end
    end

    if options[:show_thermometers]
      json.thermometers event.thermometers do |thermometer|
        ThermometerBuilder.new(thermometer).build!(json)
      end
    end

    if options[:show_polls]
      json.polls event.polls do |poll|
        PollBuilder.new(poll).build!(json)
      end
    end
  end
end
