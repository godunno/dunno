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
    !record.blocked? && record.profile == profile
  end

  def block?
    !record.removed? && teacher? && record.profile != profile
  end

  alias_method :unblock?, :block?

  def show?
    can_see_event? && !record.removed? && (!record.blocked? || teacher?)
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
