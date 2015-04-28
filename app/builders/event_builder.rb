class EventBuilder < BaseBuilder
  def build(json = Jbuilder.new, options = {})
    json.(event, :id, :uuid, :order, :status, :formatted_status)
    json.start_at(format_time(event.start_at))
    json.end_at(format_time(event.end_at))
    json.formatted_classroom([event.course.class_name, event.classroom].compact.join(' - '))

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
  end
end
