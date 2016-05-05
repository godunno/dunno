json.course do
  json.partial! 'api/v1/courses/course', course: @created_course
end
