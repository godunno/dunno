class AddLastViewedNotificationsAtToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :last_viewed_notifications_at, :datetime,
      null: false,
      default: Time.current
  end
end
