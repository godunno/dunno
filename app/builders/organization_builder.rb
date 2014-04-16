class OrganizationBuilder < BaseBuilder
  def build(json = Jbuilder.new, options = {})
    json.(organization, :uuid, :name)
  end
end
