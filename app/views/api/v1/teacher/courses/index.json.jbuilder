json.array! @courses do |course|
  CourseBuilder.new(course).build!(json)
end
