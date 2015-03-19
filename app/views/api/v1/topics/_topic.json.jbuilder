json.(topic, :uuid, :description, :order, :done, :personal)
json.media_id topic.media.try(:uuid)

json.media do
  json.partial! 'api/v1/medias/media', media: topic.media if topic.media.present?
end
