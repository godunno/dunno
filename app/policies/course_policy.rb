class CoursePolicy < ApplicationPolicy
  def show?
    has_course? && !blocked?
  end

  def create?
    true
  end

  def update?
    profile == record.teacher || profile.moderator_in?(record)
  end

  def destroy?
    profile == record.teacher
  end

  def register?
    !has_course? && !blocked?
  end

  def unregister?
    !blocked? && (role == 'student' || role == 'moderator')
  end

  alias_method :send_notification?, :update?

  alias_method :search?, :register?

  alias_method :block?, :update?

  alias_method :unblock?, :update?

  alias_method :analytics?, :show?

  private

  def has_course?
    profile.has_course?(record)
  end

  def blocked?
    profile.blocked_in?(record)
  end

  def role
    @role ||= profile.role_in(record)
  end
end
