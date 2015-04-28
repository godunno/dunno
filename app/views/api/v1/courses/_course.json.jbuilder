json.(course, :uuid, :name, :uuid, :start_date, :end_date,
      :grade, :class_name, :order, :access_code, :institution)
json.color(SHARED_CONFIG["v1"]["courses"]["schemes"][course.order])
json.students_count(course.students.count)
json.teacher(course.teacher, :name)

json.weekly_schedules course.weekly_schedules do |weekly_schedule|
  json.(weekly_schedule, :weekday, :start_time, :end_time, :classroom)
end

