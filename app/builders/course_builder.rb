class CourseBuilder < BaseBuilder
  def build(json = Jbuilder.new, options = {})
    json.(course, :uuid, :name, :uuid, :start_date, :end_date,
          :class_name, :order, :access_code, :institution)

    json.weekly_schedules course.weekly_schedules do |weekly_schedule|
      # TODO: move to builder
      json.(weekly_schedule, :weekday, :start_time, :end_time, :classroom)
    end

    json.students course.students do |student|
      # TODO: move to builder
      json.(student, :name)
    end

    # TODO: move to builder
    json.teacher(course.teacher, :name)

    if options[:show_events]
      json.events course.events do |event|
        EventBuilder.new(event).build!(
          json,
          show_course:
          false,
          event_pusher_events: options[:event_pusher_events]
        )
      end
    end
  end
end
