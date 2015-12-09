class MediaPolicy < ApplicationPolicy
  def create?
    true
  end

  def update?
    record.profile == profile
  end

  alias_method :destroy?, :update?

  def show?
    record.topics.map(&:event).map(&:course).select do |course|
      profile.has_course?(course)
    end.any?
  end
end
