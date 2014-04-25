class EventBuilder < BaseBuilder
  def build(json = Jbuilder.new, options = {})
    json.(event, :id, :title, :uuid, :duration, :start_at, :channel, :status)

    event_pusher_events = options[:event_pusher_events]
    json.(event_pusher_events, *event_pusher_events.events)

    if options[:show_course]
      json.course do
        CourseBuilder.new(event.course).build!(json, show_events: false)
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
