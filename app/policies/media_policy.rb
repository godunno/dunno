class MediaPolicy < ApplicationPolicy
  def create?
    true
  end

  def update?
    record.profile == profile &&
      (!record.folder || record.folder.course.teacher == profile)
  end

  def destroy?
    record.profile == profile
  end

  def show?
    record.topics.map(&:event).map(&:course).select do |course|
      profile.has_course?(course)
    end.any?
  end
end
