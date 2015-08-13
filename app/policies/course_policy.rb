class CoursePolicy < ApplicationPolicy
  def show?
    profile.has_course?(record)
  end

  def create?
    profile == record.teacher
  end

  def register?
    !profile.has_course?(record)
  end

  def unregister?
    profile.role_in(record) == 'student'
  end

  alias_method :update?, :create?

  alias_method :destroy?, :create?

  alias_method :send_notification?, :create?

  alias_method :search?, :register?
end
