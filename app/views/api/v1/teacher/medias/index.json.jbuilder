json.array! @medias do |media|
  MediaBuilder.new(media).build!(json)
end
