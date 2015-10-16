json.(system_notification, :notification_type)
json.created_at(format_time(system_notification.created_at))
json.read_at(format_time(system_notification.read_at))
json.author do
  json.(system_notification.author, :name, :avatar_url)
end
json.notifiable do
  json.partial! "api/v1/system_notifications/types/#{system_notification.notification_type}",
                notifiable: system_notification.notifiable
end
