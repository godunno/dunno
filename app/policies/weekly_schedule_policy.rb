class WeeklySchedulePolicy < ApplicationPolicy
  def create?
    authorize_from_course_policy(:update?)
  end

  alias_method :destroy?, :create?
  alias_method :transfer?, :create?
  alias_method :affected_events_on_transfer?, :create?

  private

  def authorize_from_course_policy(method)
    !!(record.course && CoursePolicy.new(profile, record.course).send(method))
  end
end
