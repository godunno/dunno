json.(course, :uuid, :name, :uuid, :start_date, :end_date, :abbreviation,
      :grade, :class_name, :order, :access_code, :institution)
json.color(SHARED_CONFIG["v1"]["courses"]["schemes"][course.order])
json.user_role(current_profile.role_in(course))
json.students_count(course.students.count)
json.teacher(course.teacher, :name)
json.active course.active?

json.weekly_schedules course.weekly_schedules do |weekly_schedule|
  json.(weekly_schedule, :uuid, :weekday, :start_time, :end_time, :classroom)
end

json.members_count(course.memberships.count)

json.members course.memberships do |membership|
  json.(membership.profile, :name)
  json.(membership, :role)
end
