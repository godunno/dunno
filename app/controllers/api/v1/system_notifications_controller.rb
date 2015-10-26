class Api::V1::SystemNotificationsController < Api::V1::ApplicationController
  before_action :skip_authorization
  def index
    system_notifications
  end

  def mark_all_as_read
    system_notifications.update_all(read_at: Time.current)
    render :index
  end

  def show
    @system_notification = system_notifications.find(params[:id])
    @system_notification.update(read_at: Time.current)
  end

  def new_notifications
    last_viewed = current_profile.last_viewed_notifications_at
    count = system_notifications
            .more_recent_than(last_viewed)
            .count
    render json: { new_notifications_count: count }
  end

  def viewed
    current_profile.update!(last_viewed_notifications_at: Time.current)
    render nothing: true
  end

  private

  def system_notifications
    @system_notifications ||= current_profile
                              .system_notifications
                              .without_author(current_profile)
  end
end
