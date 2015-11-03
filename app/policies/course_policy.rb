class CoursePolicy < ApplicationPolicy
  def show?
    has_course? && !blocked?
  end

  def create?
    true
  end

  def update?
    profile == record.teacher
  end

  def register?
    !has_course? && !blocked?
  end

  def unregister?
    profile.role_in(record) == 'student' && !blocked?
  end

  alias_method :destroy?, :update?

  alias_method :send_notification?, :update?

  alias_method :search?, :register?

  alias_method :block?, :update?

  alias_method :unblock?, :update?

  private

  def has_course?
    profile.has_course?(record)
  end

  def blocked?
    profile.blocked_in?(record)
  end
end
