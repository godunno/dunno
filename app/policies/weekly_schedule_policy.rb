class WeeklySchedulePolicy < ApplicationPolicy
  def create?
    authorize_from_course_policy(:update?)
  end

  alias_method :destroy?, :create?
  alias_method :transfer?, :create?

  private

  def authorize_from_course_policy(method)
    !!(record.course && CoursePolicy.new(profile, record.course).send(method))
  end
end
