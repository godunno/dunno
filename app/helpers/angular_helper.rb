module AngularHelper
  def angular_course_path(course, params = {})
    ["/dashboard#/courses/#{course.uuid}/events", params.to_param]
      .reject(&:blank?)
      .join('?')
  end

  def angular_event_path(event)
    angular_course_path(event.course, startAt: event.start_at.utc.iso8601)
  end

  def angular_comment_path(comment)
    angular_course_path comment.event.course,
                        startAt: comment.event.start_at.utc.iso8601,
                        commentId: comment.id
  end
end
