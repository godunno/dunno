json.array! @courses do |course|
  json.partial! 'models/course', course: course
end
