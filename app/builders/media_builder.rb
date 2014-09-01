class MediaBuilder < BaseBuilder
  def build(json = Jbuilder.new, options = {})
    json.(media, :uuid, :title, :description, :category)
    json.released_at(format_time(media.released_at))
    json.url(media.url || media.file.url)
  end
end
