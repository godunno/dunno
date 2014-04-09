json.(media, :uuid, :title, :description, :category)
json.url(media.url || media.file.url)
