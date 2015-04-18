json.(media, :id, :uuid, :title, :description, :category, :preview, :type, :thumbnail)
json.filename(media.original_filename)

# Necessary due to an error when serializing tags
json.tag_list(media.tag_list.as_json)
json.url(media.url)
