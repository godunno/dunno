module AngularHelper
  def angular_course_path(course, path: 'events', params: {})
    ["/dashboard#/courses/#{course.uuid}/#{path}", params.to_param]
      .reject(&:blank?)
      .join('?')
  end

  def angular_event_path(event)
    angular_course_path(event.course, params: { startAt: event.start_at.utc.iso8601 })
  end

  def angular_comment_path(comment)
    angular_course_path comment.event.course, params: {
                          startAt: comment.event.start_at.utc.iso8601,
                          commentId: comment.id
                        }
  end

  def angular_members_path(course)
    angular_course_path(course, path: 'members')
  end
end
