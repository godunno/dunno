class ApplicationPolicy
  attr_reader :profile, :record

  def initialize(profile, record)
    @profile = profile
    @record = record
  end

  def index?
    false
  end

  def show?
    scope.where(:id => record.id).exists?
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

  def scope
    Pundit.policy_scope!(profile, record.class)
  end

  class Scope
    attr_reader :profile, :scope

    def initialize(profile, scope)
      @profile = profile
      @scope = scope
    end

    def resolve
      scope
    end
  end
end
