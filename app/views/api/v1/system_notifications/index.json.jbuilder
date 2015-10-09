json.system_notifications do
  json.array! @system_notifications do |system_notification|
    json.partial! 'api/v1/system_notifications/system_notification',
      system_notification: system_notification
    json.author do
      json.(system_notification.author, :name, :avatar_url)
    end
  end
end
