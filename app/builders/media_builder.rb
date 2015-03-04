class MediaBuilder < BaseBuilder
  def build(json = Jbuilder.new, options = {})
    json.(media, :uuid, :title, :description, :category, :preview, :type, :thumbnail)
    json.filename(media.original_filename)

    # Necessary due to an error when serializing tags
    json.tag_list(media.tag_list.as_json)
    json.released_at(format_time(media.released_at))
    json.url(media.url)
  end
end
