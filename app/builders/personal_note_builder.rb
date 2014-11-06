class PersonalNoteBuilder < BaseBuilder
  def build(json = Jbuilder.new, options = {})
    json.(personal_note, :uuid, :description, :order, :done)
  end
end
