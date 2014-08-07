class CourseBuilder < BaseBuilder
  def build(json = Jbuilder.new, options = {})
    json.(course, :id, :name, :uuid, :start_date, :end_date,
          :classroom)

    if options[:show_events]
      json.events course.events do |event|
        EventBuilder.new(event).build!(json, show_course: false, event_pusher_events: options[:event_pusher_events])
      end
    end
  end
end
