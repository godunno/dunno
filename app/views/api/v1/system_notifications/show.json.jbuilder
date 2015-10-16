json.system_notification do
  json.partial! 'api/v1/system_notifications/system_notification',
                system_notification: @system_notification
end
