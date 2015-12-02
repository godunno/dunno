class TrackCommentCreatedEvent
  def initialize(comment, profile)
    self.comment = comment
    self.profile = profile
    self.course = comment.event.course
  end

  def track
    assert_is_member
    return if comment_already_tracked?
    create_tracking_event
  end

  private

  attr_accessor :comment, :profile, :course

  def last_tracked_event
    profile
      .tracking_events
      .where(trackable: course, event_type: event_type)
      .order(created_at: :desc)
      .first
  end

  def create_tracking_event
    TrackingEvent.create!(
      course: course,
      profile: profile,
      event_type: event_type,
      trackable: comment
    )
  end

  def event_type
    TrackingEvent.event_types[:comment_created]
  end

  def comment_already_tracked?
    profile.tracking_events.where(trackable: comment, event_type: event_type).any?
  end

  def assert_is_member
    return if profile.courses.include?(course)
    fail TrackingEvent::NonMemberError, non_member_error_message 
  end

  def non_member_error_message
    "Profile#id #{profile.id} isn't member of Course#id #{course.id}."
  end
end
