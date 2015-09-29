json.course do
  json.partial! 'api/v1/courses/course', course: @course
  role = current_profile.role_in(@course)
end
