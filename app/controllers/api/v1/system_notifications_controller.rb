class Api::V1::SystemNotificationsController < Api::V1::ApplicationController
  def index
    @system_notifications = current_profile.system_notifications
  end

  def new_notifications
    skip_authorization
    last_viewed = current_profile.last_viewed_notifications_at
    count = current_profile
            .system_notifications
            .more_recent_than(last_viewed)
            .count
    render json: { new_notifications_count: count }
  end

  def viewed
    skip_authorization
    current_profile.update!(last_viewed_notifications_at: Time.current)
    render nothing: true
  end
end
