class Api::V1::SystemNotificationsController < Api::V1::ApplicationController
  def index
    @system_notifications = current_profile.system_notifications.order(created_at: :desc)
  end
end
