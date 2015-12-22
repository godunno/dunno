class CommentPolicy < ApplicationPolicy
  delegate :event, to: :record
  delegate :course, to: :event

  def create?
    can_see_event? &&
      (teacher_or_moderator? ||
       event_exists? ||
       event_scheduled?)
  end

  alias_method :update?, :create?

  def destroy?
    !record.blocked? && record.profile == profile
  end

  alias_method :restore?, :destroy?

  def block?
    !record.removed? && teacher_or_moderator? && record.profile != profile
  end

  alias_method :unblock?, :block?

  def show?
    can_see_event? && !record.removed? && (!record.blocked? || teacher_or_moderator?)
  end

  private

  def can_see_event?
    !!(event && EventPolicy.new(profile, event).show?)
  end

  def event_exists?
    event.persisted?
  end

  def teacher_or_moderator?
    role == 'teacher' || role == 'moderator'
  end

  def role
    @role ||= profile.role_in(course)
  end

  def event_scheduled?
    FindWeeklySchedule.new(event.start_at, course.weekly_schedules).weekly_schedule?
  end
end
