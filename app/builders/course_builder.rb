class CourseBuilder < BaseBuilder
  def build(json = Jbuilder.new, options = {})
    json.(course, :uuid, :name, :uuid, :start_date, :end_date,
          :class_name, :order, :access_code, :institution)
    json.color(SHARED_CONFIG["v1"]["courses"]["schemes"][course.order])

    json.weekly_schedules course.weekly_schedules do |weekly_schedule|
      # TODO: move to builder
      json.(weekly_schedule, :weekday, :start_time, :end_time, :classroom)
    end

    json.students_count(course.students.count)

    if options[:show_students]
      json.students course.students do |student|
        # TODO: move to builder
        json.(student, :name)
      end
    end

    # TODO: move to builder
    if options[:show_teacher]
      json.teacher(course.teacher, :name)
    end

    # TODO: Add tests
    if options[:show_events]
      json.cache! ['course-builder-events', course.events.maximum(:updated_at)] do
        json.events course.events do |event|
          json.cache! ['course-builder-event', event] do
            EventBuilder.new(event).build!(
              json,
              show_course: false
            )
          end
        end
      end
    end
  end
end
