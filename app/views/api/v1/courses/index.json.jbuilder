json.array! @courses do |course|
  json.partial! 'api/v1/courses/course', course: course
end
