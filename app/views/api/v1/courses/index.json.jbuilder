json.array! @courses do |course|
  CourseBuilder.new(course).build!(json, show_teacher: true)
end
