class CoursePolicy < ApplicationPolicy
  def show?
    profile.has_course?(record)
  end

  def create?
    true
  end

  def update?
    profile == record.teacher
  end

  def register?
    !profile.has_course?(record)
  end

  def unregister?
    profile.role_in(record) == 'student'
  end

  alias_method :destroy?, :update?

  alias_method :send_notification?, :update?

  alias_method :search?, :register?
end
