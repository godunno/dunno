json.course do
  CourseBuilder.new(@course).build!(json, show_events: true)
end
