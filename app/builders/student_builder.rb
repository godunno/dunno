class StudentBuilder < BaseBuilder
  def build(json = Jbuilder.new, options = {})
    json.(profile, :uuid, :name, :email)
  end
end
