class CommentPolicy < ApplicationPolicy
  delegate :event, to: :record
  delegate :course, to: :event

  def create?
    can_see_event? &&
      (teacher? ||
       event_exists? ||
       event_scheduled?)
  end

  alias_method :update?, :create?

  def destroy?
    record.profile == profile
  end

  private

  def can_see_event?
    !!(event && EventPolicy.new(profile, event).show?)
  end

  def event_exists?
    event.persisted?
  end

  def teacher?
    profile.role_in(course) == 'teacher'
  end

  def event_scheduled?
    FindWeeklySchedule.new(event.start_at, course.weekly_schedules).weekly_schedule?
  end
end
