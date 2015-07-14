class CourseBuilder < BaseBuilder
  def build(json = Jbuilder.new, options = {})
    json.(course, :uuid, :name, :uuid, :start_date, :end_date,
          :grade, :class_name, :order, :access_code, :institution,
          :abbreviation)
    json.color(SHARED_CONFIG["v1"]["courses"]["schemes"][course.order])
    json.user_role(options[:profile].role_in(course))

    json.weekly_schedules course.weekly_schedules do |weekly_schedule|
      # TODO: move to builder
      json.(weekly_schedule, :weekday, :start_time, :end_time, :classroom)
    end

    json.members_count(course.memberships.count)

    json.members course.memberships do |membership|
      json.(membership.profile, :name)
      json.(membership, :role)
    end

    json.teacher(course.teacher, :name)
  end
end
