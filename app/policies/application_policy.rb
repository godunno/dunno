class ApplicationPolicy
  attr_reader :profile, :record

  def initialize(profile, record)
    @profile = profile
    @record = record
  end

  def show?
    false
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end
end
