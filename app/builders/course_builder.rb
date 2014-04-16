class CourseBuilder < BaseBuilder
  def build(json = Jbuilder.new, options = {})
    json.(course, :id, :name, :uuid, :start_date, :end_date,
          :start_time, :end_time, :classroom, :weekdays)

    if options[:show_events]
      json.events course.events do |event|
        EventBuilder.new(event).build!(json, show_course: false, pusher_events: options[:pusher_events])
      end
    end
  end
end
