class CommentPolicy < ApplicationPolicy
  def create?
    can_see_event?
  end

  alias_method :update?, :create?
  alias_method :destroy?, :create?

  private

  def can_see_event?
    !!(record.event && EventPolicy.new(profile, record.event).show?)
  end
end
