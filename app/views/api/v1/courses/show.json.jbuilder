json.course do
  json.partial! 'api/v1/courses/course', course: @course
  json.medias_count @course
                    .events
                    .published
                    .flat_map(&:topics)
                    .map(&:media)
                    .compact
                    .uniq
                    .count
end
