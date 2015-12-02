class TrackCourseAccessedEvent
  def initialize(course, profile)
    self.course = course
    self.profile = profile
  end

  def track
    assert_is_member
    return if already_tracked_today?
    create_tracking_event
  end

  private

  attr_accessor :course, :profile

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
      trackable: course
    )
  end

  def event_type
    TrackingEvent.event_types[:course_accessed]
  end

  def already_tracked_today?
    last_tracked_event && last_tracked_event.created_at.today?
  end

  def assert_is_member
    return if profile.courses.include?(course)
    fail TrackingEvent::NonMemberError, non_member_error_message 
  end

  def non_member_error_message
    "Profile#id #{profile.id} isn't member of Course#id #{course.id}."
  end
end
