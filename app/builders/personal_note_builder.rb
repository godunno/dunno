class PersonalNoteBuilder < BaseBuilder
  def build(json = Jbuilder.new, options = {})
    json.(personal_note, :uuid, :content, :order)
  end
end
