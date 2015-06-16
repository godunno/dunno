class MediaPolicy < ApplicationPolicy
  def create?
    true
  end

  def update?
    record.profile == profile
  end

  alias_method :destroy?, :update?
end
