json.folder do
  json.partial! 'api/v1/folders/folder', folder: @folder
  # json.medias @folder.medias, partial: 'api/v1/medias/media', as: :media
  json.medias @folder.medias do |media|
    MediaBuilder.new(media).build!(json, show_events: true)
  end
end
