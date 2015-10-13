class AttachmentPolicy < ApplicationPolicy
  def create?
    true
  end

  def destroy?
    record.profile == profile
  end
end
