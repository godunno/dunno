class StudentBuilder < BaseBuilder
  def build(json = Jbuilder.new, options = {})
    json.(student, :uuid, :name, :email, :avatar)
  end
end
