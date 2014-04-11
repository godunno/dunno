json.(media, :uuid, :title, :description, :category, :released_at)
json.url(media.url || media.file.url)
