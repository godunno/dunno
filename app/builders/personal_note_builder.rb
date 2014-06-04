class PersonalNoteBuilder < BaseBuilder
  def build(json = Jbuilder.new, options = {})
    json.(personal_note, :content)
  end
end
