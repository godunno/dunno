class MediaBuilder < BaseBuilder
  def build(json = Jbuilder.new, options = {})
    json.(media, :uuid, :title, :description, :category, :released_at)
    json.url(media.url || media.file.url)
  end
end
