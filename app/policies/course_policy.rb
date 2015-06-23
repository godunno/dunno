class CoursePolicy < ApplicationPolicy
  def show?
    profile.role_in(record).present?
  rescue ActiveRecord::RecordNotFound
    false
  end

  def create?
    profile == record.teacher
  end

  def register?
    !show?
  end

  def unregister?
    profile.role_in(record) == 'student'
  rescue ActiveRecord::RecordNotFound
    false
  end

  alias_method :update?, :create?

  alias_method :destroy?, :create?

  alias_method :send_notification?, :create?

  alias_method :students?, :show?

  alias_method :search?, :register?
end
