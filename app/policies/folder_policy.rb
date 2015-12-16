class FolderPolicy < ApplicationPolicy
  def create?
    profile.role_in(record.course) == 'teacher'
  end

  alias_method :destroy?, :create?
end
