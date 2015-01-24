class PersonalNoteBuilder < BaseBuilder
  def build(json = Jbuilder.new, options = {})
    json.(personal_note, :uuid, :description, :order, :done)
    if options[:show_media]
      json.media_id personal_note.media.try(:uuid)
      json.media do
        MediaBuilder.new(personal_note.media).build!(json)
      end
    end
  end
end
