class EventPolicy < ApplicationPolicy
  def show?
    authorize_from_course_policy(:show?)
  end

  def create?
    authorize_from_course_policy(:update?)
  end

  alias_method :update?, :create?
  alias_method :destroy?, :create?

  private

  def authorize_from_course_policy(method)
    !!(record.course && CoursePolicy.new(profile, record.course).send(method))
  end
end
