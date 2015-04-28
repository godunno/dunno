json.(topic, :uuid, :done, :personal, :media_id)
json.description(topic.media.try(:title) || topic.description)

json.media do
  json.partial! 'api/v1/medias/media', media: topic.media if topic.media.present?
end
