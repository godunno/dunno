json.course do
  CourseBuilder.new(@course).build!(json, show_events: true, show_students: true)
end
